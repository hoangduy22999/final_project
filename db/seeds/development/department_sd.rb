# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT DEPARTMENT')

DEPARTMENTS = %w[RUBY PHP JAVA REACT HR MARKETING ADMIN].freeze
users = User.all.pluck(:id)
time_now = Date.current

department_attribute = DEPARTMENTS.map do |department|
  { name: department
    manager_id: users.sample
    user_departments_attributes: users.sample(rand(3..9)).pluck(:id).map do |user_id|
      {
        user_id: user_id,
        role: rand(0..2),
        start_date: time_now,
        end_date: time_now + 1.years
      }
    end
  }
end

db_resources = Department.pluck(:id)
missing_resources = reject_skipping_resources(department_attribute, db_resources, 'name')
missing_resources&.count&.times { |time| Department.create(missing_resources[time]) }