# frozen_string_literal: true

class TimeSheet < ApplicationRecord
  # relationships
  belongs_to :user

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

  # scopes
  scope :check_today, lambda { |user_id, day|
    where(user_id: user_id, keeping_time: day)
  }

  # function
  def time_late
    if keeping_type == 'check_in'
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
        return ((keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME)- keeping_time) / 60).to_i
      end
    end
  end

  private

  def check_today
    return unless TimeSheet.find_by(user_id: user_id, keeping_type: keeping_type, keeping_time: keeping_time.all_day)

    errors.add(:base, "You has been #{keeping_type.titleize} today")
  end

  def check_out_time
    return if keeping_type =='check_in' || TimeSheet.find_by(user_id: user_id, keeping_time: keeping_time.all_day, keeping_type: 'check_in')&.keeping_time < keeping_time

    errors.add(:base, 'Checkin time greater than Checkout time')
  end


  def check_in_today
    return if keeping_type =='check_in' || TimeSheet.find_by(user_id: user_id, keeping_time: keeping_time.all_day, keeping_type: 'check_in')

    errors.add(:base, 'You are not checking in today')
  end
end
