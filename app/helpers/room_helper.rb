module RoomHelper
  def status_room_options
    Room.statuses.keys.each_with_object([['-- Choose Status --', '']]) do |status, object|
      object << [status.titleize, status]
    end
  end

  def days_of_week_for_select(room)
    array = (Date::DAYNAMES[1..] << Date::DAYNAMES.first).each_with_index.map { |day, index| [day, index] }
    options_for_select array, room.rest_day
  end

  def show_wday(wdays)
    wdays.compact.map { |wday| Date::DAYNAMES[wday] }.join(', ')
  end
end