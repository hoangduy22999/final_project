# == Schema Information
#
# Table name: user_leave_times
#
#  id          :bigint           not null, primary key
#  leave_max   :float            default(0.0), not null
#  leave_taken :float            default(0.0), not null
#  leave_type  :integer          default("paid"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  user_id     :bigint           not null
#
class UserLeaveTime < ApplicationRecord
  # relationships
  belongs_to :user
  has_many :leave_requests, through: :user

  # enums
  enum leave_type: {
    paid: 0,
    unpaid: 1
  }, _prefix: true
  
  # ransacker for enums
  ransacker :leave_type, formatter: proc { |key| leave_types[key] }

  # function
  def leave_remain
    leave_max - leave_taken
  end
end
