# frozen_string_literal: true

class Department < ApplicationRecord
  # relationships
  has_many :user_departments, dependent: :destroy
  has_many :users, through: :user_departments
  belongs_to :manager, class_name: 'User', foreign_key: 'manager_id'

  # nested attributes
  accepts_nested_attributes_for :user_departments, allow_destroy: true
end
