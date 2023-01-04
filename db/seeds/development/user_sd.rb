# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT USER')

districts = District.all.pluck(:id)

user_attributes = (1..19).to_a.map do |_department|
  {}
end

db_resources = User.pluck(:id)
missing_resources = reject_skipping_resources(user_attributes, db_resources, 'email')
missing_resources&.count&.times { |time| User.create(missing_resources[time]) }
