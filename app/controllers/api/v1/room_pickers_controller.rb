class Api::V1::RoomPickersController < Api::V1::ApplicationApi
  skip_before_action :authorized, only: %i[index]
  before_action :set_room_picker, only: %i[update destroy]

  def index
    room_pickers = RoomPicker.includes(:user, :room).ransack(params[:where]).result.order(start_at: :desc)

    render_index(room_pickers, RoomPickers::IndexSerializer, params[:page] || 1, room_pickers.count || 0)
  end

  def create
    service = V1::Api::TimeSheets::CreateService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, TimeSheets::IndexSerializer)
  end

  def update
    service = V1::Api::TimeSheets::CreateService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, TimeSheets::IndexSerializer)
  end

  def destroy
    service = V1::Api::TimeSheets::CreateService.new(params, {current_user: current_user})
    service.perform
    data = service.data

    render_success(data, TimeSheets::IndexSerializer)
  end

  private

  def set_room_picker
    @room_picker = RoomPicker.find(params[:id])
  end

  def room_picker_params
    params.require(:room_picker).permit(:room_id, :start_at, :end_at, :repeat_type)
  end
end