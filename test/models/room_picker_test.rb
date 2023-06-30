# == Schema Information
#
# Table name: room_pickers
#
#  id          :bigint           not null, primary key
#  description :text
#  end_at      :datetime
#  repeat      :boolean          default(FALSE)
#  repeat_type :integer          default("one_time")
#  start_at    :datetime
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  room_id     :integer
#  user_id     :bigint
#
# Foreign Keys
#
#  room  (room_id => rooms.id)
#  user  (user_id => users.id)
#
require "test_helper"

class RoomPickerTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
