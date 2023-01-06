# frozen_string_literal: true

class City < ApplicationRecord
  # relationships
  has_many :districts, dependent: :destroy
  has_many :users, through: :districts

  # nested attributes
  accepts_nested_attributes_for :districts
end
