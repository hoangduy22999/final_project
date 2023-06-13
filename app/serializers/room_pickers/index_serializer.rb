class RoomPickers::IndexSerializer < ActiveModel::Serializer
  attributes :id, :description, :repeat, :repeat_type, :room_id, :user_id

  attribute(:title) { object.description }
  attribute(:user) { object.user.full_name }
  attribute(:start) { object.start_at.strftime("%FT%T") }
  attribute(:end) { object.end_at.strftime("%FT%T") }
  attribute(:color) { object.room.color }
  attribute(:textColor) { text_color(object.room.color) }

  private
  
  def text_color(hex)
    hex = Room::COLOR[hex.to_sym] unless hex.start_with?('#')
    rgb = hex.match(/^#(..)(..)(..)$/).captures.map(&:hex)
    if rgb[0] * 0.299 + rgb[1] * 0.587 + rgb[2] * 0.114 > 186
      'black'
    else
      'white'
    end
  end
end