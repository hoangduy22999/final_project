# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT LEAVE REQUEST')

skip_user_ids = LeaveRequest.pluck(:user_id)
leader_ids = UserDepartment.role_leader.pluck(:user_id)


attributes = (User.where.not(id: skip_user_ids).pluck(:id) * 10).map do |user_id|
  {
    created_by: user_id,
    user_id: user_id,
    leave_type: rand(0..4),
    status: rand(0..2),
    on_time: rand(0..3),
    approve_by: leader_ids.sample
  }
end

db_resources = City.pluck(:name)
missing_resources = reject_skipping_resources(attributes, db_resources, 'name')
missing_resources&.count&.times { |time| City.create(missing_resources[time]) }