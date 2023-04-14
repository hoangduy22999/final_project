class Leader::LeaveRequestsController < Leader::BaseController
  before_action :set_leave_request, only: %i[update]

  def index
    @leave_requests = LeaveRequest.status_pending.where(approve_by: current_user.id)
  end

  def update
    respond_to do |format|
      if @leave_request.update(leave_request_param)
        format.html { redirect_to leader_leave_requests_path, notice: 'Holiday was successfully updated.' }
      else
        format.html { redirect_to leader_leave_requests_path, alert: @holiday.errors.full_messages.first }
      end
    end
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  end

  def leave_request_param
    params.require(:leave_request).permit(:status)
  end
end