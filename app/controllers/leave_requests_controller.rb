class LeaveRequestsController < ApplicationController
  include LeaveRequestHelper

  before_action :set_leave_request, only: [:update, :destroy]

  def index
    @leave_requests = current_user.leave_requests.includes(user: [:user_department, :department])
                                                 .ransack(convert_date_params(params)).result
                                                 .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = current_user.leave_requests.new(leave_request_params.merge(created_by: current_user.id))
    if @leave_request.save
      redirect_to leave_requests_path, notice: "Leave Request has been create successfully"
    else
      redirect_to leave_requests_path, alert: @leave_request.errors.full_messages.first
    end
  end

  def update
    return redirect_to leave_requests_path, alert: "Can't update approve or reject leave request" unless @leave_request.status_pending?

    if @leave_request.update(leave_request_params)
      redirect_to leave_requests_path, notice: "Leave Request has been update successfully"
    else
      redirect_to leave_requests_path, alert: @leave_request.errors.full_messages.first
    end
  end

  def destroy
    return redirect_to leave_requests_path, alert: "Can't remove approve or reject leave request" unless @leave_request.status_pending?

    @leave_request.destroy

    respond_to do |format|
      format.html do
        redirect_to leave_requests_path,
                    notice: 'Leave Request was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  end

  def leave_request_params
    params.require(:leave_request).permit(:leave_type, :approve_by, :start_date, :end_date, :reason, :on_time, :reference_ids)
  end
end