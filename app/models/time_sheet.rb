# frozen_string_literal: true

class TimeSheet < ApplicationRecord
  # relationships
  belongs_to :user

  # validates
  validate :check_today

  # enums
  enum keeping_type: {
    check_in: 0,
    check_out: 1
  }, _prefix: true

  private

  def check_today
    return unless TimeSheet.find_by(user_id: user_id, keeping_type: keeping_type, keeping_time: keeping_time.all_day)

    errors.add(:base, "You has been #{keeping_type.titleize} today")
  end
end
