class Leader::LeaveRequestsController < Leader::BaseController
  before_action :set_leave_request, only: %i[update]

  def index
    @leave_requests = current_user.leave_requests_need_approve
                                  .includes(user: [:user_department, :department])
                                  .ransack((params[:where] || {}).merge(status_eq: "pending")).result
                                  .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
  end

  def update
    respond_to do |format|
      if @leave_request.update(leave_request_param)
        format.html { redirect_to leader_leave_requests_path, notice: "Leave request was successfully #{@leave_request.status}." }
      else
        format.html { redirect_to leader_leave_requests_path, alert: @leave_request.errors.full_messages.first }
      end
    end
  end

  def update_multi
    leave_requests = LeaveRequest.where(id: leave_request_ids)
    respond_to do |format|
      if leave_requests.present? && leave_requests.update_all(leave_requests_param)
        format.html { redirect_to leader_leave_requests_path, notice: "Leave request was successfully #{leave_requests&.first&.status}." }
      else
        format.html { redirect_to leader_leave_requests_path, alert: leave_requests&.first&.errors&.full_messages&.first || "Leave request was empty" }
      end
    end
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  end

  def leave_request_param
    params.require(:leave_request).permit(:status)["status"].eql?("approve") ? {status: "approved"} : {status: "rejected"}
  end

  def leave_requests_param
    params["commit"].eql?("Approve all") ? {status: "approved"} : {status: "rejected"}
  end

  def leave_request_ids
    params["leave_request_ids"].split(",").map(&:to_i)
  end
end