class Api::V1::RoomPickersController < Api::V1::ApplicationApi
  before_action :set_room_picker, only: %i[update destroy]

  def index
    service = V1::Api::RoomPickers::IndexService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_index(data, RoomPickers::RepeatSerializer)
  end

  def repeat
    service = V1::Api::RoomPickers::RepeatService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_index(data, RoomPickers::RepeatSerializer)
  end

  def create
    service = V1::Api::RoomPickers::CreateService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, RoomPickers::IndexSerializer)
  end

  def update
    service = V1::Api::RoomPickers::UpdateService.new(params, {current_user: current_user, object: @room_picker})
    service.perform
    data = service.data

    render_success(data, RoomPickers::IndexSerializer)
  end

  def destroy
    service = V1::Api::RoomPickers::DestroyService.new(params, {current_user: current_user, object: @room_picker})
    service.perform
    data = service.data

    render_success(data, RoomPickers::IndexSerializer)
  end

  private

  def set_room_picker
    @room_picker = RoomPicker.find_by(id: params[:id])

    raise NotFound unless @room_picker

    raise Unauthorized unless @room_picker.user_id.eql?(current_user.id)
  end

  def room_picker_params
    params.require(:room_picker).permit(:room_id, :start_at, :end_at, :repeat_type)
  end
end