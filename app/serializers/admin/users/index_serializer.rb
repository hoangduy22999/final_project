class Admin::Users::IndexSerializer < ActiveModel::Serializer
  attributes :id, :age

  attribute (:name) { object.full_name.titleize }
  attribute (:department) { object.department.name.humanize }
end