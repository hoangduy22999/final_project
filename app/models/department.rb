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
class Department < ApplicationRecord
  # relationships
  has_many :user_departments, dependent: :destroy
  has_many :users, through: :user_departments
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id', optional: true

  # nested attributes
  accepts_nested_attributes_for :user_departments, allow_destroy: true
end
