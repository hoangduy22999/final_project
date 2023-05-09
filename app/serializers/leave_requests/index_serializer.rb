class LeaveRequests::IndexSerializer < ActiveModel::Serializer
  attributes :id, :leave_type, :approve_by, :reason
end
