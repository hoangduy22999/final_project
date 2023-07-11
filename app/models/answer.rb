# frozen_string_literal: true

# == Schema Information
#
# Table name: answers
#
#  id          :bigint           not null, primary key
#  content     :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  question_id :bigint           not null
#  user_id     :bigint           not null
#
# Foreign Keys
#
#  question  (question_id => questions.id)
#  user      (user_id => users.id)
#
class Answer < ApplicationRecord
  # relationship
  belongs_to :question
  belongs_to :user
end
