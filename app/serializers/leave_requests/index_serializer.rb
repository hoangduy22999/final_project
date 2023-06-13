class LeaveRequests::IndexSerializer < ActiveModel::Serializer
  attributes :id, :leave_type, :approve_by, :reason

  attribute(:start) { object.start_date.strftime("%FT%T") }
  attribute(:end) { object.end_date.strftime("%FT%T") }
  attribute(:title) { object.leave_type.humanize + ' ' + object.start_date.strftime("%H:%M%p") + '-' + object.end_date.strftime("%H:%M%p") }
end
