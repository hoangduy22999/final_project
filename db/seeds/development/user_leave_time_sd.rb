skip_user_ids = UserLeaveTime.pluck(:user_id)
user_ids = User.where.not(id: skip_user_ids).pluck(:id)
users_count = user_ids.count
types = UserLeaveTime.leave_types

attributes = (user_ids * 2 ).map.with_index do |user_id, index|
  {
    user_id: user_id,
    leave_max: rand(16..24),
    leave_taken: rand(0..16),
    leave_type: index >= users_count ? types["paid"] : types["unpaid"]
  }
end

db_resources = UserLeaveTime.pluck(:user_id)
missing_resources = reject_skipping_resources(attributes, db_resources, 'user_id')
missing_resources&.count&.times { |time| UserLeaveTime.create(missing_resources[time]) }