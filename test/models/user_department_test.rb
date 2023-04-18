# frozen_string_literal: true

# == Schema Information
#
# Table name: user_departments
#
#  id            :bigint           not null, primary key
#  end_date      :datetime
#  role          :integer          default("leader"), not null
#  start_date    :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_user_departments_on_department_id  (department_id)
#  index_user_departments_on_user_id        (user_id)
#
# Foreign Keys
#
#  department  (department_id => departments.id)
#  user        (user_id => users.id)
#
require 'test_helper'

class UserDepartmentTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
