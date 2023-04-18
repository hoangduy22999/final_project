# frozen_string_literal: true

# == Schema Information
#
# Table name: time_sheets
#
#  id           :bigint           not null, primary key
#  change_by    :integer          default("user")
#  keeping_time :datetime
#  keeping_type :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class TimeSheet < ApplicationRecord
  # relationships
  belongs_to :user
  has_one :department, through: :user

  # validates
  validates :user, :keeping_type, presence: true
  validate :check_today, unless: -> { keeping_time.blank? }, on: :create
  validate :check_out_time, :check_in_today, unless: -> { keeping_time.blank? }
  validates :keeping_time, presence: true, date: { before_or_equal_to: Time.now.end_of_day }

  # enums
  enum keeping_type: {
    check_in: 0,
    check_out: 1
  }, _prefix: true

  enum change_by: {
    user: 0,
    admin: 1
  }, _prefix: true

  # scopes
  scope :check_today, lambda { |user_id, day|
    where(user_id: user_id, keeping_time: day)
  }

  # function
  def time_late
    return 0 if TimeSheet.where(keeping_time: keeping_time.all_day, user_id: user_id).count <= 1
    if keeping_type == 'check_in'
      return 0 if keeping_time <= keeping_time.change(hour: CHECK_IN_MORNING_TIME)
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_MORNING_TIME) && keeping_time <= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      if keeping_time >= keeping_time.change(hour: CHECK_IN_MORNING_TIME) && keeping_time <= keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
        return ((keeping_time - keeping_time.change(hour: CHECK_IN_MORNING_TIME)) / 60).to_i
      end

      if keeping_time >= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
        ((keeping_time - keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)) / 60).to_i
      end
    else
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_MORNING_TIME) && keeping_time < keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      if keeping_time < keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
        return ((keeping_time.change(hour: CHECK_OUT_MORNING_TIME) - keeping_time) / 60).to_i
      end

      if keeping_time > keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
        ((keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME) - keeping_time) / 60).to_i
      end
    end
  end

  def present
    return 0 if keeping_type.eql?('check_out') || keeping_time >= keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
    ts = TimeSheet.find_by(user_id: user_id, keeping_type: 'check_out', keeping_time: keeping_time.all_day)
    check_out_time = ts&.keeping_time
    return 0 if ts.blank? || check_out_time <= check_out_time.change(hour: CHECK_IN_MORNING_TIME)

    diff_time = ((check_out_time - keeping_time) / 60).to_i
    if keeping_time <= keeping_time.change(hour: CHECK_IN_MORNING_TIME)
      return 8 * 60 if check_out_time >= check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      return diff_time if check_out_time < check_out_time.change(hour: CHECK_OUT_MORNING_TIME)
      return ((keeping_time.change(hour: CHECK_OUT_MORNING_TIME) - keeping_time) / 60).to_i if check_out_time < check_out_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      diff_time - 60
    elsif keeping_time <= keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
      return diff_time if check_out_time <= check_out_time.change(hour: CHECK_OUT_MORNING_TIME)
      return 4 * 60 if check_out_time > check_out_time.change(hour: CHECK_OUT_MORNING_TIME) && check_out_time <= check_out_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      return ((keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME) - keeping_time) / 60).to_i - 60 if check_out_time > check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      diff_time - 60
    elsif keeping_time <= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      return 0 if check_out_time < check_out_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      return ((check_out_time - keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)) / 60).to_i if check_out_time < check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      4 * 60
    else
      return diff_time if check_out_time < check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      ((keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME) - keeping_time) / 60).to_i
    end
  end

  private

  def check_today
    return if TimeSheet.find_by(user_id: user_id, keeping_type: keeping_type, keeping_time: keeping_time.all_day).blank?

    errors.add(:base, "You has been #{keeping_type.titleize} today")
  end

  def check_out_time
    return if keeping_type =='check_in' || TimeSheet.find_by(user_id: user_id, keeping_time: keeping_time.all_day, keeping_type: 'check_in')&.keeping_time < keeping_time

    errors.add(:base, 'Checkin time greater than Checkout time')
  end

  def check_in_today
    return if keeping_type == 'check_in' || TimeSheet.find_by(user_id: user_id, keeping_time: keeping_time.all_day, keeping_type: 'check_in') || change_by == 'admin'

    errors.add(:base, 'You are not checking in today')
  end
end
