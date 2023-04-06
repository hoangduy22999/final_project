# frozen_string_literal: true

class LeaveRequest < ApplicationRecord
  # enum
  enum on_time: {
    morning: 0,
    afternoon: 1,
    all_day: 2
  }, _prefix: true

  enum status: {
    pending: 0,
    approved: 1,
    reject: 2
  }, _prefix: true

  # function
  def references
    User.where(id: reference_ids)
  end
end
