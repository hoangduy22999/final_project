#  id         :bigint           not null, primary key
#  content    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null

skip_user_ids = Question.pluck(:user_id)
attributes = User.where.not(id: skip_user_ids).map do |user|
  {
    content: Faker::TvShows::SiliconValley.quote,
    user_id: user.id
  }
end

db_resources = Question.pluck(:content)
missing_resources = reject_skipping_resources(attributes, db_resources, 'content')
missing_resources&.count&.times { |time| Question.create(missing_resources[time]) }