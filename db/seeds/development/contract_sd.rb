skip_user_ids = Contract.pluck(:user_id)
now = Time.zone.now

attributes = User.where.not(id: skip_user_ids).map do |user|
  {
    user_id: user.id,
    base_salary: Faker::Number.between(from: 1000000, to: 20000000),
    contract_type: rand(0..3),
    description: Faker::Lorem.sentence(word_count: 3),
    end_date: Faker::Date.between(from: now, to: 1.year.from_now),
    payment_form: rand(0..2),
    start_date: Faker::Date.between(from: 1.year.ago, to: now),
  }
end

db_resources = Contract.pluck(:user_id)
missing_resources = reject_skipping_resources(attributes, db_resources, 'user_id')
missing_resources&.count&.times { |time| Contract.create(missing_resources[time]) }