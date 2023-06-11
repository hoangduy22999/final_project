# == Schema Information
#
# Table name: rooms
#
#  id          :bigint           not null, primary key
#  capacity    :integer
#  color       :string
#  description :string
#  end_at      :time
#  name        :string
#  rest_day    :integer          default([]), is an Array
#  start_at    :time
#  status      :integer          default("available"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class RoomTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
