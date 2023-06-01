class RoomPickersController < ApplicationController
  def index
    @room_pickers = RoomPicker.ransack(params[:where]).result
                              .order('created DESC')
  end
end