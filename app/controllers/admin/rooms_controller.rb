class Admin::RoomsController < Admin::BaseController
  before_action :set_room, only: %i[show update destroy]

  def index
    @rooms = Room.ransack(params[:where]).result
                 .order(created_at: :desc)
                 .paginate(page: params[:page] || 1, per_page: params[:per_page] || PER_PAGE_BIG)
  end

  def new
    @room = Room.new
  end

  def create
    @room = Room.new(room_params)
    if @room.save
      redirect_to admin_rooms_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('rooms.dashboard_name').downcase)
    else
      redirect_to new_admin_room_path(@room), alert: @room.errors.full_messages.first
    end
  end

  def show; end

  def update
    if @room.update(room_params)
      redirect_to admin_rooms_path, notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('rooms.dashboard_name').downcase)
    else
      redirect_to admin_rooms_path, alert: @room.errors.full_messages.first
    end
  end

  def destroy
    if @room.destroy
      redirect_to admin_rooms_path, notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('rooms.dashboard_name').downcase)
    else
      redirect_to admin_rooms_path, alert: @room.errors.full_messages.first
    end
  end

  private

  def set_room
    @room = Room.find(params[:id])
  end

  def room_params
    params.require(:room).permit(:id, :name, :description, :capacity, :status, :start_at, :end_at, :color, :rest_day => [])
  end
end