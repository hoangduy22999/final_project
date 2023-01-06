# frozen_string_literal: true

class City < ApplicationRecord
  # relationships
  has_many :districts, dependent: :destroy

  # nested attributes
  accepts_nested_attributes_for :districts
end
