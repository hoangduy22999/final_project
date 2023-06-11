# == Schema Information
#
# Table name: messages
#
#  id          :bigint           not null, primary key
#  content     :string
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  receiver_id :bigint
#  sender_id   :bigint
#
# Indexes
#
#  index_messages_on_receiver_id  (receiver_id)
#  index_messages_on_sender_id    (sender_id)
#
class Message < ApplicationRecord
  # relationship
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'
  belongs_to :receiver, class_name: 'User', foreign_key: 'receiver_id'

  # validates
  validates :content, presence: true

  # scope
  scope :user_messages, -> (user_id) { where(sender_id: user_id).or(where(receiver_id: user_id)) }
end
