# == Schema Information
#
# Table name: company_settings
#
#  id                  :bigint           not null, primary key
#  allow_languages     :string           default([]), is an Array
#  allow_late_time     :float            default(0.0)
#  apply_from          :datetime
#  apply_to            :datetime
#  check_in_afternoon  :string
#  check_in_morning    :string
#  check_out_afternoon :string
#  check_out_morning   :string
#  status              :integer          default("active")
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
require "test_helper"

class CompanySettingTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
