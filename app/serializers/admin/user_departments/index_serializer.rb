class Admin::UserDepartments::IndexSerializer < ActiveModel::Serializer
  attribute (:user_id) { object[:user_id] }
  attribute (:user_name) { object[:user_name]}
  attribute (:user_age) { object[:user_age]}
end