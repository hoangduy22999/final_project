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
require 'test_helper'

class LeaveRequestTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
