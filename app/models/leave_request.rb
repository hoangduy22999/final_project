# frozen_string_literal: true

# == Schema Information
#
# Table name: leave_requests
#
#  id            :bigint           not null, primary key
#  approve_by    :bigint
#  created_by    :integer
#  end_date      :datetime
#  leave_type    :integer
#  reason        :text
#  reference_ids :bigint           is an Array
#  start_date    :datetime
#  status        :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Foreign Keys
#
#  approve_by  (approve_by => users.id)
#  user        (user_id => users.id)
#
class LeaveRequest < ApplicationRecord
  # validates
  validates :end_date, :leave_type, presence: true
  validates :start_date, presence: true, date: { before_or_equal_to: :end_date }
  validate :approve_by_leader

  # relationship
  belongs_to :user
  belongs_to :approve_user, class_name: 'User', foreign_key: "approve_by"
  belongs_to :created_user, class_name: 'User', foreign_key: "created_by"

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
    compensatory_leave: 4,
    forgot_kepping: 5
  }, _prefix: true

  enum keeping_type: {
    check_in: 0,
    check_out: 1
  }, _prefix: true

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
  ransacker :leave_type, formatter: proc { |key| leave_types[key] }

  # function
  def references
    User.where(id: reference_ids)
  end

  # private methods
  private

  def approve_by_leader
    return if User.find_by(id: approve_by)&.leader_department?

    errors.add(:approve_by, "Only leader department can be approved")
  end
end
