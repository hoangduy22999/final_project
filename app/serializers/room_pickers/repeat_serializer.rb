class RoomPickers::RepeatSerializer < ActiveModel::Serializer
  attribute(:id) {object[:id]}
  attribute(:editable) { object[:editable] }
  attribute(:user) { object[:user_name] }
  attribute(:start) { object[:start_at].strftime("%FT%T") }
  attribute(:end) { object[:end_at].strftime("%FT%T") }
  attribute(:color) { object[:room_color] }
  attribute(:textColor) { object[:room_text_color] }
  attribute(:description ) { object[:description] }
  attribute(:title) { object[:description] }
  attribute(:room_id) { object[:room_id] }
  attribute(:repeat_type) { object[:repeat_type] }
  attribute(:repeat) { object[:repeat] }
end