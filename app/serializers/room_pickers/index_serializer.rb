class RoomPickers::IndexSerializer < ActiveModel::Serializer
  attributes :id, :description, :repeat, :repeat_type, :room_id, :user_id

  attribute(:room) { object.room.name }
  attribute(:user) { object.user.full_name }
  attribute(:start) { object.start_at.strftime("%FT%T") }
  attribute(:end) { object.end_at.strftime("%FT%T") }
end