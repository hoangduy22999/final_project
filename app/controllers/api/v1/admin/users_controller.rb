class Api::V1::Admin::UsersController < Api::V1::Admin::AdminsController
  def index
    service = V1::Api::Admin::Users::IndexService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_index(data, Admin::Users::IndexSerializer, service.page_params, data.total_pages)
  end
end