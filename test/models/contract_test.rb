# == Schema Information
#
# Table name: contracts
#
#  id                 :bigint           not null, primary key
#  base_salary        :integer
#  contract_type      :integer
#  description        :string
#  end_date           :date
#  payment_form       :integer
#  start_date         :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_department_id :bigint
#
# Foreign Keys
#
#  user_department  (user_department_id => user_departments.id)
#
require "test_helper"

class ContractTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
