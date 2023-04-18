class LeaveRequestsController < ApplicationController
  before_action :set_leave_request, only: [:update, :destroy]

  def index
    @leave_requests = current_user.leave_requests.includes(user: [:user_department, :department])
                                                 .ransack((params[:where] || {})).result
                                                 .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = current_user.leave_requests.create(leave_request_params.merge(created_by: current_user.id))
    if @leave_request.save
      redirect_to leave_requests_path, notice: "Time Sheet has been create successfully"
    else
      redirect_to leave_requests_path, alert: @leave_request.errors.full_messages.first
    end
  end

  def update
    if @leave_request.update(leave_request_params)
      redirect_to leave_requests_path, notice: "Time Sheet has been create successfully"
    else
      redirect_to leave_requests_path, alert: @leave_request.errors.full_messages.first
    end
  end

  def destroy
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])
  end

  def leave_request_params
    params.require(:leave_request).permit(:leave_type, :approve_by, :start_date, :end_date, :reason, :on_time, :reference_ids)
  end
end