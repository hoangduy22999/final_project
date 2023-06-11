# == Schema Information
#
# Table name: room_pickers
#
#  id          :bigint           not null, primary key
#  description :text
#  end_at      :datetime
#  repeat      :boolean          default(FALSE)
#  repeat_type :integer          default(0)
#  start_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer
#  user_id     :bigint
#
class RoomPicker < ApplicationRecord
  # relationship
  belongs_to :user
  belongs_to :room

  # validation
  validates :start_at, presence: true, date: { before_or_equal_to: :end_at}
  validates :end_at, presence: true

  enum repeat_type: {
    daily: 0,
    weekly: 1,
    monthly: 2,
    yearly: 3,
    one_time: 4
  }, _prefix: true
end
