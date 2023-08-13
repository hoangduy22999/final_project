class TimeSheetService
  attr_reader :user_ids, :start_month, :end_month, :time_sheets

  def initialize(params = {})
    time = params[:year_month]
    @user_ids = params[:user_ids]
    @start_month = time.beginning_of_month
    @end_month = time.end_of_month
    @time_sheets = TimeSheet.where(start_at: start_month.all_month, user_id: user_ids)
  end

  def perform 
    calculte
  end

  private

  def calculte
    check_in_morning, check_out_morning, check_in_afternoon, check_out_afternoon = CompanySetting.current_time_settings
    options = {
                check_in_morning: check_in_morning,
                check_out_morning: check_out_morning,
                check_in_afternoon: check_in_afternoon,
                check_out_afternoon: check_out_afternoon
              }
    total = total_times
    time_sheets.group_by {|ts| ts.user_id}.map do |user_id, user_time_sheets|
      forgot_keppings = user_time_sheets.select{|elm| elm.start_at.nil? || elm.end_at.nil?}
      normal_keepings = user_time_sheets - forgot_keppings
      {
        user_id: user_id,
        present_times: normal_keepings.sum { |elm| elm.time_present(options).first },
        late_times: normal_keepings.sum { |elm| elm.time_present(options).last },
        forgot_keepings: forgot_keppings.count,
        total_times: total
      }
    end
  end

  def total_times
    holidays = Holiday.status_active
                      .in_month(start_month)
                      .map {|holiday| (holiday.start_date.day..holiday.end_date.day).map {|day| day}}
                      .flatten
                      .uniq
    tmp_start_date = start_month
    tmp_end_date = end_month
    while(tmp_end_date >= tmp_start_date) do
      holidays.push(tmp_start_date.day) if tmp_start_date.wday == 0 || tmp_start_date.wday == 6
      tmp_start_date += 1.days
    end
    (end_month.day - holidays.uniq.count) * CompanySetting.current_time_one_day
  end
end