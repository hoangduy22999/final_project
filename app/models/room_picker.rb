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
  validate :validate_duplicate_time

  enum repeat_type: {
    one_time: 0,
    daily: 1,
    weekly: 2,
    monthly: 3,
    yearly: 4
  }, _prefix: true

  private

  def validate_duplicate_time
    return unless RoomPicker.where(room_id: room_id)
                            .where("(start_at >= ? AND end_at <= ?) OR (start_at >= ? AND end_at <= ?)", start_at, end_at, start_at, end_at)
                            .where.not(id: id)
                            .exists?

    errors.add(:base, "Duplicate time in same room")
  end
end
