class TimeSheets::IndexSerializer < ActiveModel::Serializer
  attributes :id, :keeping_type, :keeping_time
  attribute(:keeping_date) { object.keeping_time.to_date }
  attribute(:keeping_time) { object.keeping_time.strftime("%T") }
end