class Api::V1::UsersController < Api::V1::ApplicationApi
  def leaders
    service = V1::Api::Leaders::IndexService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_index(data, Leaders::IndexSerializer, service.page_params, data.total_pages)
  end

  def profile
    render_success(current_user, Users::IndexSerializer)
  end
end