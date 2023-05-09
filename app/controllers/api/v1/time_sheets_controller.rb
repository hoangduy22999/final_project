class Api::V1::TimeSheetsController < Api::V1::ApplicationApi
  def index
    service = V1::Api::TimeSheets::IndexService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_index(data, TimeSheets::IndexSerializer, service.page_params, data.total_pages)
  end

  def create
    service = V1::Api::TimeSheets::CreateService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, TimeSheets::IndexSerializer)
  end
end