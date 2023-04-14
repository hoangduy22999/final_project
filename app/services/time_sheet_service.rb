class TimeSheetService
  attr_reader :user_id, :start_month, :end_month, :current_keeping_type, :check_out_today

  def initialize(params = {})
    time = params[:year_month]
    @user_id = params[:user_id]
    @start_month = time.beginning_of_month
    @end_month = time.end_of_month
    @current_keeping_type = params[:current_keeping_type]
    @check_out_today = params[:check_out_today]
  end

  def perfom
    calc
  end

  private


  def calc
    result = []
    current_month = start_month.month
    time_sheets = TimeSheet.where(keeping_time: start_month.all_month, user_id: @user_id).order(:keeping_time)
    time_sheets, total_time_late, present = hash_timesheet(time_sheets)
    start_date = start_month.beginning_of_week
    end_date = end_month.end_of_week
    while start_date < end_date
      tmp_day = start_date.day
      weekend = weekend?(start_date)
      result << if start_date.month != current_month
                   { day: tmp_day, current_month: false, weekend: false }
                 elsif !time_sheets[tmp_day]
                   { day: tmp_day, current_month: true, weekend: weekend }
                 else
                   time_sheets[tmp_day]
                 end
      start_date += 1.days
    end
    time_sheet = TimeSheet.new(keeping_type: current_keeping_type)
    { result: result, time_sheet: time_sheet, disabled: check_out_today, total_time_late: total_time_late, full_hours: full_hours, present: present }
  end

  def hash_timesheet(time_sheets)
    total_time_late = 0
    present = 0
    time_sheets = time_sheets.map do |ts|
      time_late = ts.time_late
      total_time_late += ts.time_late
      present += ts.present
      keeping_time = ts.keeping_time
      { day: keeping_time.day, time: keeping_time.strftime('%H:%M'), type: ts.keeping_type, time_late: ts.time_late, weekend: weekend?(keeping_time) }
    end.group_by { |a| a[:day] } 
    [time_sheets, total_time_late, present]
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
    start_month.to_date.upto(end_month.to_date) do |day|
      days << day.day if day.sunday? || day.saturday?
    end
    days
  end

  def holidays
    days = []
    all_month = start_month.all_month
    Holiday.status_active.where(start_date: all_month).or(Holiday.status_active.where(end_date: all_month)).each do |holiday|
      start_date = holiday.start_date
      end_date = holiday.end_date
      include_start_date = all_month.cover?(start_date)
      time_range = if include_start_date && all_month.cover?(end_date)
                      start_date..end_date
                    elsif include_start_date
                      start_date..all_month.last
                    else
                      all_month.first..end_date
                    end
      time_range.each { |day| days << day.day }
    end
    days
  end

  def weekend?(date)
    date.sunday? || date.saturday?
  end
end