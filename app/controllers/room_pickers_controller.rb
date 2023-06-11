class RoomPickersController < ApplicationController
  def index
    @room_pickers = RoomPicker.includes(:room, :user)
                              .ransack(params[:where]).result
                              .order('created_at DESC')
  end
end