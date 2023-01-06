# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT DEPARTMENT')

DEPARTMENTS = %w[RUBY PHP JAVA REACT HR MARKETING ADMIN].freeze
users = User.all.pluck(:id)
time_now = Date.current
departments = Department.pluck(:name)

department_attribute = DEPARTMENTS.map do |department|
  next if departments.include?(department)

  Department.create({
                      name: department,
                      manager_id: users.sample,
                      user_departments_attributes: users.sample(rand(3..9)).map.with_index do |user_id, index|
                                                     {
                                                       user_id: user_id,
                                                       role: index > 1 ? 2 : index,
                                                       start_date: time_now,
                                                       end_date: time_now + 1.years
                                                     }
                                                   end
                    })
end
