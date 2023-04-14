class LeaveRequestsController < ApplicationController
  before_action :set_leave_request, only: [:update, :destroy]

  def index
    @leave_requests = current_user.leave_requests
    @leave_request = LeaveRequest.new
  end

  def create
    @leave_request = current_user.leave_requests.create(leave_request_params)
    if @leave_request.save
    else
    end
  end

  def update
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