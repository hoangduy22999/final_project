# frozen_string_literal: true

# == Schema Information
#
# Table name: questions
#
#  id         :bigint           not null, primary key
#  content    :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class Question < ApplicationRecord
  belongs_to :user
  has_many :answers, dependent: :destroy
end
