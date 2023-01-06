# frozen_string_literal: true

class District < ApplicationRecord
  # relationships
  belongs_to :city
end
