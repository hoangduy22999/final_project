class Api::V1::CitiesController < Api::V1::ApplicationApi
  skip_before_action :authorized

  def index
    service = V1::Api::Cities::IndexService.new(
      params, {current_user: current_user}
    )
    service.perform
    data = service.data
    render status: 200,
           json: data,
           adapter: :json,
           root: 'data',
           each_serializer: Cities::IndexSerializer,
           meta: { page: service.page_params, page_number: data.total_pages }
  end
end