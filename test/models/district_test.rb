# frozen_string_literal: true

# == Schema Information
#
# Table name: districts
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  name_with_type :string           not null
#  path           :string           not null
#  path_with_type :string           not null
#  slug           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  city_id        :integer          not null
#
# Indexes
#
#  index_districts_on_name  (name)
#
# Foreign Keys
#
#  city  (city_id => cities.id)
#
require 'test_helper'

class DistrictTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
