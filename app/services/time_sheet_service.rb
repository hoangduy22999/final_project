class TimeSheetService
  attr_reader :user_id, :time, :current_keeping_type, :check_out_today

  def initialize(params = {})
    @user_id = params[:user_id]
    @time = params[:year_month]
    @current_keeping_type = params[:current_keeping_type]
    @check_out_today = params[:check_out_today]
  end

  def perfom
    calc
  end

  private


  def calc
    result = []
    current_month = time.month
    time_sheets = TimeSheet.where(keeping_time: @time.all_month, user_id: @user_id).order(:keeping_time)
    total_time_late = 0
    time_sheets = time_sheets.map do |ts|
      time_late = ts.time_late
      total_time_late += ts.time_late
      { day: ts.keeping_time.day, time: ts.keeping_time.strftime('%H:%M'), type: ts.keeping_type, time_late: ts.time_late }
    end.group_by { |a| a[:day] }
    start_date = time.beginning_of_month.beginning_of_week
    end_date = time.end_of_month.end_of_week
    while start_date < end_date
      tmp_day = start_date.day
      result << if start_date.month != current_month
                   { day: tmp_day, current_month: false }
                 elsif !time_sheets[tmp_day]
                   { day: tmp_day, current_month: true }
                 else
                   time_sheets[tmp_day]
                 end
      start_date += 1.days
    end
    time_sheet = TimeSheet.new(keeping_type: current_keeping_type)
    { result: result, time_sheet: time_sheet, disabled: check_out_today, total_time_late: total_time_late}
  end
end