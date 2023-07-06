# == Schema Information
#
# Table name: contracts
#
#  id            :bigint           not null, primary key
#  base_salary   :integer
#  contract_type :integer
#  deleted_at    :datetime
#  description   :string
#  end_date      :date
#  payment_form  :integer
#  start_date    :date
#  status        :integer          default("active"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
require "test_helper"

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
