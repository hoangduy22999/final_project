# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT USER')

districts = District.all.pluck(:id)
departments = Department.all.pluck(:id)

user_attributes = (0..(19 - User.all.count)).to_a.map do |index|
  User.create!({
                 first_name: Faker::Name.first_name,
                 last_name: Faker::Name.last_name,
                 email: "user-0#{index}@email.com",
                 password: 'User123456*',
                 password_confirmation: 'User123456*',
                 birthday: Faker::Date.birthday(min_age: 18, max_age: 65),
                 role: rand(0..1),
                 gender: rand(0..2),
                 status: rand(0..1),
                 district_id: districts.sample,
                 address: Faker::Address.street_address,
                 phone: Faker::PhoneNumber.subscriber_number(length: 11),
                 avatar: Faker::LoremFlickr.image
               })
end
