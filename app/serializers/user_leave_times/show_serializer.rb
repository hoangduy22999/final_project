class UserLeaveTimes::ShowSerializer < ActiveModel::Serializer
  attributes :id, :leave_max, :leave_taken, :leave_type
end