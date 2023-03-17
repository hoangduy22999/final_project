# frozen_string_literal: true

class TimeSheet < ApplicationRecord
  # relationships
  belongs_to :user

  # validates
  validates :keeping_time, :user, :keeping_type, presence: true
  validate :check_today, :check_out_time, unless: -> { keeping_time.blank? }

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
      binding.pry
      return 0 if keeping_time <= keeping_time.change(hour: CHECK_IN_MORNING_TIME)
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_MORNING_TIME) && keeping_time <= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      if keeping_time >= keeping_time.change(hour: CHECK_IN_MORNING_TIME) && keeping_time <= keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
        return ((keeping_time - keeping_time.change(hour: CHECK_IN_MORNING_TIME)) / 60).to_i
      end

      if keeping_time >= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
        return ((keeping_time - keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)) / 60).to_i
      end
    else
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_MORNING_TIME) && keeping_time < keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      if keeping_time < keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
        return ((keeping_time.change(hour: CHECK_OUT_MORNING_TIME) - keeping_time) / 60).to_i
      end

      if keeping_time > keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
        return ((keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)- keeping_time) / 60).to_i
      end
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
