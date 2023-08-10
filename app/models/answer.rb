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
  # const
  I18N_MESSAGES = {created: "notifications.answers.created", updated: "notifications.answers.updated"}

  # callbacks
  after_commit :create_notifications, on: :create

  # relationship
  belongs_to :question
  belongs_to :user
  has_many :notifications, as: :resource, dependent: :destroy

  # private scope
  private

  def create_notifications
    notifications.create!({
      message: Answer::I18N_MESSAGES[:created],
      recipient_id: question.user_id,
      sender_id: user_id,
      action_type: Notification.action_types[:created]
    })
  end
end
