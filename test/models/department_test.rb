# frozen_string_literal: true

# == Schema Information
#
# Table name: departments
#
#  id         :bigint           not null, primary key
#  name       :string           not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  manager_id :integer
#
# Indexes
#
#  index_departments_on_manager_id  (manager_id)
#  index_departments_on_name        (name)
#
# Foreign Keys
#
#  user  (manager_id => users.id)
#
require 'test_helper'

class DepartmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
