class Api::V1::LeaveRequestsController < Api::V1::ApplicationApi
  before_action :set_leave_request, only: [:update, :destroy]

  def index
    service = V1::Api::LeaveRequests::IndexService.new(
      params, {current_user: current_user}
    )
    service.perform
    data = service.data

    render status: 200,
            json: data,
            adapter: :json,
            root: 'data',
            each_serializer: LeaveRequests::IndexSerializer,
            meta: { page: service.page_params, page_number: data.total_pages }
  end

  def create
  end

  def update
  end

  def destroy
  end

  private

    def set_leave_request
      @leave_request = LeaveRequest.find_by(params[:id])

      raise NotFound unless @leave_request
    end

    def leave_request_params
      params.require(:leave_request).permit(:leave_type, :approve_by, :start_date, :end_date, :reason, :on_time, :reference_ids)
    end
end