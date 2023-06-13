class Holidays::IndexSerializer < ActiveModel::Serializer
  attributes :id

  attribute(:title) { object.name }
  attribute(:start) { object.start_date.strftime("%FT%T") }
  attribute(:end) { object.end_date.strftime("%FT%T") }
  attribute(:color) { 'orange' }
  attribute(:allDay) { true }
  attribute(:borderColor) { 'white' }
end