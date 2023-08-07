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
require "test_helper"

class UserLeaveTimeTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
