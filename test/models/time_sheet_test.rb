# frozen_string_literal: true

# == Schema Information
#
# Table name: time_sheets
#
#  id         :bigint           not null, primary key
#  change_by  :integer          default("user")
#  end_at     :datetime
#  start_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
require 'test_helper'

class TimeSheetTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
