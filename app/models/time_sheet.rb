# frozen_string_literal: true

class TimeSheet < ApplicationRecord
  # relationships
  belongs_to :user

  # validates
  validate :check_today, :check_out_time

  # enums
  enum keeping_type: {
    check_in: 0,
    check_out: 1
  }, _prefix: true

  # scopes
  scope :check_today, lambda { |user_id, day|
    where(user_id: user_id, keeping_time: day)
  }

  # function
  def time_late
    if keeping_type == 'check_in'
      check_in_time =  keeping_time.hour >= CHECK_IN_AFTERNOON_TIME ? CHECK_IN_AFTERNOON_TIME : CHECK_IN_MORNING_TIME
      check_in_late =  ((keeping_time - keeping_time.change(hour: check_in_time)) / 60).to_i
    else
      check_out_time = check_out.keeping_time.hour >= CHECK_OUT_AFTERNOON_TIME ? CHECK_OUT_AFTERNOON_TIME : CHECK_OUT_MORNING_TIME
      check_out_late = ((check_out.keeping_time - check_out.keeping_time.change(hour: check_out_time)) / 60).to_i
    end
  end

  private

  def check_today
    return unless TimeSheet.find_by(user_id: user_id, keeping_type: keeping_type, keeping_time: keeping_time.all_day)

    errors.add(:base, "You has been #{keeping_type.titleize} today")
  end

  def check_out_time
    check_reverse = TimeSheet.find_by(user_id: user_id,
                                      keeping_type: keeping_type == 'check_in' ? 'check_out' : 'check_in', keeping_time: keeping_time.all_day)
    return unless check_reverse

    checkin_greater_than_checkout = keeping_type == 'check_in' ? (check_reverse.keeping_time > keeping_time) : (keeping_time > check_reverse.keeping_time)
    return if checkin_greater_than_checkout

    errors.add(:base, 'Check In time greater than Checkout time')
  end
end
