require 'csv'

class LeaveRequestsController < ApplicationController
  include LeaveRequestHelper

  before_action :set_leave_request, only: [:update, :destroy, :show]

  def index
    @leave_requests = current_user.leave_requests.includes(user: [:user_department, :department])
                                                 .ransack(convert_date_params(params)).result
                                                 .order(start_date: :desc)
                                                 .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
  end

  def create
    @leave_request = current_user.leave_requests.new(leave_request_params.merge(created_by: current_user.id))
    if @leave_request.save
      redirect_to leave_requests_path, notice: "Leave Request has been create successfully"
    else
      redirect_to new_leave_request_path, alert: @leave_request.errors.full_messages.first
    end
  end

  def new
    @leave_request = LeaveRequest.new
  end

  def show; end

  def update
    if @leave_request.update(leave_request_params)
      redirect_to leave_request_path(@leave_request), notice: "Leave Request has been update successfully"
    else
      redirect_to leave_request_path(@leave_request), alert: @leave_request.errors.full_messages.first
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

  def export
    @leave_requests = current_user.leave_requests.includes(user: [:user_department, :department])
                                  .ransack(convert_date_params(params)).result
                                  .order(start_date: :desc)
                                  .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
    respond_to do |format|
      format.csv do
        response.headers['Content-Type'] = 'text/csv'
        response.headers['Content-Disposition'] = "attachment; filename=leave_requests-#{Date.today}-#{current_user.full_name}.csv"
        render template: "leave_requests/export.csv.erb"
      end
    end
  end

  private

  def set_leave_request
    @leave_request = LeaveRequest.find(params[:id])

    permission_denied_response unless can? :manage, @leave_request
  end

  def leave_request_params
    params.require(:leave_request).permit(:leave_type, :approve_by, :start_date, :end_date, :reason, :reference_ids, :envidence, :message)
  end
end