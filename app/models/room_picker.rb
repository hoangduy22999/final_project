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
  validate :denied_past_time, on: :create

  # scopes
  scope :repeat_pickers, ->{where.not(repeat_type: "one_time")}

  # enums
  enum repeat_type: {
    one_time: 0,
    daily: 1,
    weekly: 2,
    monthly: 3,
    yearly: 4
  }, _prefix: true

  # ransacker for enums
  ransacker :repeat_type, formatter: proc { |key| repeat_types[key] }

  private

  def validate_duplicate_time
    time_range = (start_at..end_at)
    duplicate_repeat_room = RoomPicker.all.any? do |picker|
      start_at_in_this_day = picker.start_at.change(year: start_at.year, month: start_at.month, day: start_at.day)
      end_at_in_this_day = picker.end_at.change(year: start_at.year, month: start_at.month, day: start_at.day)
      next false unless time_range.cover?(start_at_in_this_day) || time_range.cover?(end_at_in_this_day)
      next false if picker.repeat && picker.end_at < start_at
      case picker.repeat_type
      when 'weekly'
        picker.start_at.wday.eql? start_at.wday
      when 'monthly'
        picker.start_at.day.eql? start_at.day
      when 'yearly'
        picker.start_at.day.eql?(start_at.day) && picker.start_at.month.eql?(start_at.month)
      when 'one_time'
        picker.start_at.all_day.cover?(start_at)
      else
        true
      end
    end

    return unless duplicate_repeat_room

    errors.add(:base,  I18n.t("activerecord.errors.models.room_picker.attributes.base.validate_duplicate_time"))
  end


  def denied_past_time
    return if start_at >= Time.zone.now
    
    errors.add(:base, I18n.t("activerecord.errors.models.room_picker.attributes.base.denied_past_time"))
  end
end
