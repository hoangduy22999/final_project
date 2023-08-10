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
  # callback
  after_commit :create_notifications, on: :create

  # const
  MAX_CODE_LENGTH = 5
  I18N_MESSAGES = {created: "notifications.questions.created", updated: "notifications.questions.updated"}

  # relationship
  belongs_to :user
  has_many :answers, dependent: :destroy
  has_many :notifications, as: :resource, dependent: :destroy

  # functions
  def generate_code
    id_length = id.to_s.length
    id_length > MAX_CODE_LENGTH ? id : ((MAX_CODE_LENGTH - id_length) * "0" + id.to_s)
  end

  private

  def create_notifications
    User.role_admin.each do |admin|
      notifications.create!({
        message: Question::I18N_MESSAGES[:created],
        recipient_id: admin.id,
        sender_id: user_id,
        action_type: Notification.action_types[:created]
      })
    end
  end
end
