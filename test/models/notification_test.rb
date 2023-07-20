# == Schema Information
#
# Table name: notifications
#
#  id            :bigint           not null, primary key
#  action_type   :integer          default("created"), not null
#  is_readed     :boolean          default(FALSE), not null
#  message       :string           not null
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recipient_id  :integer          not null
#  resource_id   :integer
#  sender_id     :integer          not null
#
require "test_helper"

class NotificationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
