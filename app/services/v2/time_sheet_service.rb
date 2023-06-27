class V2::TimeSheetService
  attr_reader :user_ids, :start_month, :end_month, :time_sheets

  def initialize(params = {})
    time = params[:year_month]
    @user_ids = params[:user_ids]
    @start_month = time.beginning_of_month
    @end_month = time.end_of_month
    @time_sheets = TimeSheet.where(keeping_time: start_month.all_month, user_id: user_ids).order(:keeping_time)
  end

  def perform 
    calculte
  end

  private

  def calculte
    user_time_sheets = present_times
    user_ids.map do |user_id|
      user_time_sheet = user_time_sheets.select { |time_sheet| time_sheet[:user_id].to_i.eql?(user_id) }
      { 
        user_id: user_id,
        present_times: TimeSheet.strftime_format(user_time_sheet&.sum{|elm| elm[:present_time]} || 0),
        late_times: TimeSheet.strftime_format(user_time_sheet&.sum{|elm| elm[:late_time]} || 0),
        forgot_keepings: user_time_sheet&.count{|elm| elm[:forgot_keeping]} || 0
      }
    end
  end

  def present_times
    time_sheets.group_by {|a| a.user_id}.map { |user_id, time_sheets| time_sheets.group_by{|elm| elm.keeping_time.strftime("%Y-%m-%d")}.map do |day, ts|
      present_time, late_time = TimeSheet.present_time(ts.first.keeping_time.strftime("%T"), ts.last.keeping_time.strftime("%T"))
      { 
        day: day,
        user_id: user_id,
        forgot_keeping: ts.map(&:keeping_type).uniq.size < 2,
        present_time: present_time,
        late_time: late_time
      } 
    end
    }.flatten
  end
end