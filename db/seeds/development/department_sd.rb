# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT DEPARTMENT')

DEPARTMENTS = %w[RUBY PHP JAVA REACT HR MARKETING ADMIN].freeze
users = User.all.pluck(:id)

attributes = DEPARTMENTS.map do |department|
  {
    name: department,
    manager_id: users.sample
  }
end
