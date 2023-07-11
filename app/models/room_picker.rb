# == Schema Information
#
# Table name: room_pickers
#
#  id          :bigint           not null, primary key
#  description :text
#  end_at      :datetime
#  repeat      :boolean          default(FALSE)
#  repeat_type :integer          default("one_time")
#  start_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer
#  user_id     :bigint
#
# Foreign Keys
#
#  room  (room_id => rooms.id)
#  user  (user_id => users.id)
#
class RoomPicker < ApplicationRecord
  # relationship
  belongs_to :user
  belongs_to :room

  # validations
  validates :start_at, presence: true, date: { before_or_equal_to: :end_at}
  validates :end_at, presence: true
  validate :validate_duplicate_time
  validate :validate_past_time, on: :create

  # enums
  enum repeat_type: {
    one_time: 0,
    daily: 1,
    weekly: 2,
    monthly: 3,
    yearly: 4
  }, _prefix: true

  # ransacker for enums
  ransacker :repeat_type, formatter: proc { |key| reapeat_types[key] }

  private

  def validate_duplicate_time
    return unless RoomPicker.where(room_id: room_id)
                            .where("(start_at >= ? AND end_at <= ?) OR (start_at >= ? AND end_at <= ?)", start_at, end_at, start_at, end_at)
                            .where.not(id: id)
                            .exists?

    errors.add(:base, "Duplicate time in same room")
  end


  def validate_past_time
    return if start_at >= Time.zone.now
    
    errors.add(:base, "Can't select time in the past")
  end
end
