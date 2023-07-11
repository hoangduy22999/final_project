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
require "test_helper"

class UserLeaveTimeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end