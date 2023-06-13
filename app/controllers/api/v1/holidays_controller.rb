class Api::V1::HolidaysController < Api::V1::ApplicationApi
  skip_before_action :authorized, only: %i[index create update destroy]

  def index
    service = V1::Api::Holidays::IndexService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_index(data, Holidays::IndexSerializer)
  end

  def create
    service = V1::Api::Holidays::CreateService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, Holidays::IndexSerializer)
  end
end