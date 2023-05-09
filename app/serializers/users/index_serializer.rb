class TimeSheets::IndexSerializer < ActiveModel::Serializer
  attributes :id, :keeping_type, :keeping_time
end