# == Schema Information
#
# Table name: user_leave_times
#
#  id                 :bigint           not null, primary key
#  paid_leave_max     :float            default(0.0), not null
#  paid_leave_taken   :float            default(0.0), not null
#  unpaid_leave_max   :float            default(0.0), not null
#  unpaid_leave_taken :float            default(0.0), not null
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_id            :bigint           not null
#
class UserLeaveTime < ApplicationRecord
  # validates
  validates :paid_leave_max, :paid_leave_taken, :unpaid_leave_max, :unpaid_leave_taken, presence: true

  # relationships
  belongs_to :user
  has_many :leave_requests, through: :user
  
  # ransacker for enums
  ransacker :leave_type, formatter: proc { |key| leave_types[key] }

  # function
  def paid_leave_remain
    paid_leave_max - paid_leave_taken
  end

  def unpaid_leave_remain
    unpaid_leave_max - unique_leave_taken
  end
end
