# frozen_string_literal: true

# == Schema Information
#
# Table name: cities
#
#  id             :bigint           not null, primary key
#  name           :string           not null
#  name_with_type :string           not null
#  slug           :string           not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_cities_on_name  (name)
#
require 'test_helper'

class CityTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
