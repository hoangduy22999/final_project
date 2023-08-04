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
    time_sheets.group_by {|ts| ts.user_id}.map do |user_id, user_time_sheets|
      {
        user_id: user_id,
        present_times: TimeSheet.strftime_format(user_time_sheets.sum { |elm| elm.time_present(options).first }),
        late_times: TimeSheet.strftime_format(user_time_sheets.sum { |elm| elm.time_present(options).last }),
        forgot_keepings: user_time_sheets.count{|elm| elm.start_at.nil? || elm.end_at.nil? }
      }
    end
  end
end