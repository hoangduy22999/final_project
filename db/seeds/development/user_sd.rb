# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT USER')
districts = District.all.pluck(:id)
time_now = Time.zone.now
skip_department_ids = UserDepartment.pluck(:department_id)
user_index = User.last&.id || 0

Department.where.not(id: skip_department_ids).pluck(:id).each.with_index(1) do |department_id, _index|
  user_count = UserDepartment.where(department_id: department_id).count
  (0..(10 - user_count)).to_a.map do |user|
    user_index += 1
    User.create!({
                   first_name: Faker::Name.first_name,
                   last_name: Faker::Name.last_name,
                   email: "user-#{user_index}@email.com",
                   password: 'User123456*',
                   password_confirmation: 'User123456*',
                   birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
                   role: rand(0..1),
                   gender: rand(0..2),
                   status: rand(0..1),
                   district_id: districts.sample,
                   address: Faker::Address.street_address,
                   phone: Faker::PhoneNumber.subscriber_number(length: 11),
                   avatar: Faker::LoremFlickr.image,
                   user_department_attributes: {
                     department_id: department_id,
                     role: user > 2 ? 2 : user,
                     start_date: time_now,
                     end_date: time_now + 1.years
                   }
                 })
  end
end
