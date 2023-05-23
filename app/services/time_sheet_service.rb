class TimeSheetService
  attr_reader :user_id, :start_month, :end_month

  def initialize(params = {})
    time = params[:year_month]
    @user_id = params[:user_id]
    @start_month = time.beginning_of_month
    @end_month = time.end_of_month
  end

  def perfom
    calc
  end

  private

  def calc
    result = []
    current_month = start_month.month
    time_sheets = TimeSheet.where(keeping_time: start_month.all_month, user_id: @user_id).order(:keeping_time)
    disabled, current_keeping_type = keeping_button_value(time_sheets)
    time_sheet = TimeSheet.new(keeping_type: current_keeping_type)
    leave_requests = LeaveRequest.where(user_id: user_id, start_date: start_month.all_month).order(:start_date)
    time_sheets, total_time_late, present = hash_timesheet(time_sheets)
    start_date = start_month.beginning_of_week
    end_date = end_month.end_of_week
    while start_date < end_date
      tmp_day = start_date.day
      weekend = weekend?(start_date)
      leave_request = leave_requests.select { |lr| lr.start_date.day.eql?(tmp_day) }
      leave_hash = leave_request.map {|lr| { day: tmp_day, type: "leave_request", time_range: "#{lr.start_date.strftime('%H:%M')} - #{lr.end_date.strftime('%H:%M')}", status: lr.status, type: lr.leave_type}}
      result << if start_date.month != current_month
                   { day: tmp_day, current_month: false, weekend: false }
                 elsif !time_sheets[tmp_day]
                  leave_hash << { day: tmp_day, current_month: true, weekend: weekend }
                 else
                   time_sheets[tmp_day] + leave_hash
                 end
      start_date += 1.days
    end

    { 
      result: result,
      time_sheet: time_sheet,
      disabled: disabled,
      total_time_late: total_time_late,
      full_hours: full_hours,
      present: present 
    }
  end

  def hash_timesheet(time_sheets)
    total_time_late = 0
    time_present = 0
    time_sheets = time_sheets.map do |ts|
      time_late = time_late(time_sheets, ts)
      total_time_late += time_late
      time_present += time_present(time_sheets, ts)
      keeping_time = ts.keeping_time
      { day: keeping_time.day, time: keeping_time.strftime('%H:%M'), type: ts.keeping_type, time_late: time_late, weekend: weekend?(keeping_time) }
    end.group_by { |a| a[:day] } 
    [time_sheets, total_time_late, time_present]
  end

  def time_late(time_sheets, time_sheet)
    return 0 if time_sheets.select { |ts| ts.keeping_time.all_day.cover?(time_sheet.keeping_time) }.pluck(:keeping_type).uniq.count <= 1

    time_sheet.time_late
  end

  def time_present(time_sheets, time_sheet)
    keeping_today = time_sheets.select { |ts| ts.keeping_time.all_day.cover?(time_sheet.keeping_time) }
    return 0 if keeping_today.pluck(:keeping_type).uniq.count <= 1 || time_sheet.keeping_type.eql?("check_out")

    check_out_time = keeping_today.find { |ts| ts.keeping_type.eql?("check_out")}.keeping_time

    time_sheet.time_present(check_out_time)
  end

  def keeping_button_value(time_sheets)
    keeping_today = time_sheets.select { |time_sheet| time_sheet.keeping_time.all_day.cover?(Time.now) }
    current_keeping_type = "check_out"
    current_keeping_type = "check_in" if keeping_today.find { |ts| ts.keeping_type.eql?("check_in") }.blank?
    check_out_today = keeping_today.pluck(:keeping_type).include?("check_out") || !(start_month..end_month).cover?(Time.now)
    [check_out_today, current_keeping_type]
  end

  def full_hours
    all_month = start_month.all_month
    rest_days = (weekend_days + holidays).uniq
    count = 0
    start_month.to_date.upto(end_month.to_date) do |day|
      next if rest_days.include?(day.day)
      count += 1
    end
    count * 8
  end

  def weekend_days
    days = []
    start_month.to_date.upto(end_month.to_date) do |date|
      days << date.day if weekend?(date)
    end
    days
  end

  def holidays
    days = []
    all_month = start_month.all_month
    Holiday.status_active.where(start_date: all_month).or(Holiday.status_active.where(end_date: all_month)).each do |holiday|
      start_date = holiday.start_date.to_date
      end_date = holiday.end_date.to_date
      start_date = all_month.cover?(start_date) ? start_date : all_month.first.to_date
      end_date = all_month.cover?(end_date) ? end_date : all_month.last.to_date
      start_date.upto(end_date) { |date| days << date.day }
    end
    days
  end

  def weekend?(date)
    date.sunday? || date.saturday?
  end
end