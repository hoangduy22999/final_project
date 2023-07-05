#  id          :bigint           not null, primary key
#  content     :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#  user_id     :bigint           not null

skip_question_ids = Answer.pluck(:question_id)
admin_ids = User.role_admin.pluck(:id)
attributes = Question.where.not(id: skip_question_ids).map do |question|
  {
    content: Faker::TvShows::SiliconValley.quote,
    user_id: admin_ids.sample,
    question_id: question.id
  }
end

db_resources = Answer.pluck(:content)
missing_resources = reject_skipping_resources(attributes, db_resources, 'content')
missing_resources&.count&.times { |time| Answer.create(missing_resources[time]) }