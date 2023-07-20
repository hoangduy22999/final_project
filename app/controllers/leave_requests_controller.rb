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
      redirect_to leave_requests_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('leave_requests.dashboard_name').downcase)
    else
      redirect_to new_leave_request_path, alert: @leave_request.errors.full_messages.first
    end
  end

  def new
    @leave_request = LeaveRequest.new
  end

  def show
    if notification = Notification.find_by(id: params[:notification_id])
      notification.update(is_readed: 1)
    end
  end

  def update
    if @leave_request.update(leave_request_params)
      redirect_to leave_request_path(@leave_request), notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('leave_requests.dashboard_name').downcase)
    else
      redirect_to leave_request_path(@leave_request), alert: @leave_request.errors.full_messages.first
    end
  end

  def destroy
    return redirect_to leave_requests_path, alert: I18n.t('active_controller.errors.leave_requests.cannot_remove_not_pending') unless @leave_request.status_pending?

    @leave_request.destroy

    respond_to do |format|
      format.html do
        redirect_to leave_requests_path, notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('leave_requests.dashboard_name').downcase)
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