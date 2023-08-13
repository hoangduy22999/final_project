class LeaveTimeService
  attr_reader :user_ids, :start_month, :end_month, :leave_requests

  def initialize(params = {})
    time = params[:year_month]
    @user_ids = params[:user_ids]
    @leave_requests = LeaveRequest.status_approved.where(start_date: time.beginning_of_month.all_month, user_id: user_ids)
  end

  def perform 
    calculte
  end

  private

  def calculte
    leave_requests.group_by {|ts| ts.user_id}.map do |user_id, user_leave_request|
      {
        user_id: user_id,
        leave_paid: user_leave_request.select{|leave_request| leave_request.leave_taken_type.eql?("paid") && !leave_request.leave_type.eql?("forgot_keeping") }
                                      .sum {|leave_request| leave_request.total_time_in_minutes},
        leave_unpaid: user_leave_request.select{|leave_request| leave_request.leave_taken_type.eql?("unpaid")}.sum {|leave_request| leave_request.total_time_in_minutes}
      }
    end
  end
end