class Api::V1::TimeSheetsController < Api::V1::ApplicationApi
  def index
    service = V1::Api::TimeSheets::IndexService.new(
      params, {current_user: current_user}
    )
    service.perform
    data = service.data
    render status: 200,
           json: data,
           adapter: :json,
           root: 'data',
           each_serializer: TimeSheets::IndexSerializer,
           meta: { page: service.page_params, page_number: data.total_pages }
  end
end