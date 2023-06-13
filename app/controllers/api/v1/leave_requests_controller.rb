class Api::V1::LeaveRequestsController < Api::V1::ApplicationApi
  before_action :set_leave_request, only: [:update, :destroy]
  skip_before_action :authorized, only: %i[index create update destroy]

  def index
    service = V1::Api::LeaveRequests::IndexService.new(
      params, {current_user: current_user}
    )
    service.perform
    data = service.data

    render_index(data, LeaveRequests::IndexSerializer, service.page_params, data.total_pages)
  end

  def create
    service = V1::Api::TimeSheets::CreateService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, LeaveRequests::IndexSerializer)
  end

  def update
    service = V1::Api::TimeSheets::UpdateService.new(params, {current_user: current_user, object: @leave_request})
    service.perform
    data = service.data
    render_success(data, LeaveRequests::IndexSerializer)
  end

  def destroy
    service = V1::Api::TimeSheets::DestroyService.new(params, {current_user: current_user, object: @leave_request})
    service.perform
    data = service.data
    render_success(data, LeaveRequests::IndexSerializer)
  end

  private

    def set_leave_request
      @leave_request = LeaveRequest.find_by(params[:id])

      raise NotFound unless @leave_request

      raise NotFound if @leave_request.status_approved?
    end
end