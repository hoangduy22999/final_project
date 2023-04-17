# frozen_string_literal: true

class LeaveRequest < ApplicationRecord
  # relationship
  belongs_to :user

  # enum
  enum on_time: {
    morning: 0,
    afternoon: 1,
    all_day: 2,
    multi_day: 3
  }, _prefix: true

  enum status: {
    pending: 0,
    approved: 1,
    rejected: 2
  }, _prefix: true

  enum leave_type: {
    late: 0,
    paid_leave: 1,
    unpaid_leave: 2,
    over_time: 3,
    compensatory_leave: 4
  }, _prefix: true

  # function
  def references
    User.where(id: reference_ids)
  end
end
