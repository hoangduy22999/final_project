# == Schema Information
#
# Table name: action_histories
#
#  id            :bigint           not null, primary key
#  action_type   :integer
#  changed_value :json
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :string
#  user_id       :bigint
#
require "test_helper"

class ActionHistoryTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
