skip_leave_request_ids = Notification.where(resource_type: LeaveRequest.to_s).pluck(:resource_id)


LeaveRequest.where.not(id: skip_leave_request_ids).each do |leave_request|
  leave_request.notifications.create!({
    message: "notifications.new_leave_request",
    sender_id: leave_request.user_id,
    recipient_id: leave_request.approve_by
  })
end