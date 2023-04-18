# frozen_string_literal: true

# == Schema Information
#
# Table name: holidays
#
#  id          :bigint           not null, primary key
#  description :text
#  end_date    :date
#  name        :string
#  start_date  :date
#  status      :integer          default("inactive"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require 'test_helper'

class HolidayTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
