class Leaders::IndexSerializer < ActiveModel::Serializer
  attributes :id
  attribute(:name) { object.name_with_department }
end