module LeaveRequestHelper
  def leader_options
    UserDepartment.includes(:user, :department).role_leader.each_with_object([['-- Choose Leader --', '']]) do |leader, object|
      user = leader.user
      object << [user.full_name + " - " + leader.department.name, user.id]
    end
  end

  def leave_type_options
    LeaveRequest.leave_types.keys.each_with_object([['-- Choose Type --', '']]) do |leave_type, object|
      object << [leave_type.titleize, leave_type]
    end
  end
end