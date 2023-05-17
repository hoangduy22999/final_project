# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT LEAVE REQUEST')

skip_user_ids = LeaveRequest.pluck(:user_id)
leaders = UserDepartment.includes(department: :users).role_leader
user_department = UserDepartment.pluck(:department_id, :user_id).to_h
current_time = Time.now
last_day = current_time.end_of_month.day

attributes = (User.where.not(id: skip_user_ids).pluck(:id) * 10).map do |user_id|
  leader = leaders.sample
  date = current_time.change(day: (0..last_day).to_a.sample).to_date
  LeaveRequest.create!({
    created_by: user_id,
    user_id: user_id,
    leave_type: rand(0..4),
    status: rand(0..2)
    approve_by: leader.user_id,
    start_date: date,
    end_date: date,
    reference_ids: leader.department.users.last(10).pluck(:id)
  })
end