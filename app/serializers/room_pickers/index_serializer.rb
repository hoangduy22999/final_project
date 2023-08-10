class RoomPickers::IndexSerializer < ActiveModel::Serializer
  attributes :id, :repeat, :repeat_type, :room_id, :user_id

  attribute(:title) { object.description }
  attribute(:user) { object.user.full_name }
  attribute(:start) { object.start_at.strftime("%FT%T") }
  attribute(:end) { object.end_at.strftime("%FT%T") }
  attribute(:color) { object.room.color }
  attribute(:textColor) { object.room.text_color }
end