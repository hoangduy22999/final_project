module RoomPickerHelper
  def room_available
    Room.status_available.map { |room| [room.id, room.name] }
  end

  def repeat_option
    RoomPickers.repeat_types.map { |type, value| [type, value] }
  end
end