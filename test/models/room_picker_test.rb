# == Schema Information
#
# Table name: room_pickers
#
#  id          :bigint           not null, primary key
#  description :text
#  end_at      :datetime
#  repeat      :boolean          default(FALSE)
#  repeat_type :integer          default(0)
#  start_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer
#  user_id     :bigint
#
require "test_helper"

class RoomPickerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
