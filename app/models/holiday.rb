# frozen_string_literal: true

class Holiday < ApplicationRecord
  validates :name, :start_date, :end_date, presence: true
  validates :start_date, date: { before_or_equal_to: :end_date }
  # enum
  enum status: {
    inactive: 0,
    active: 1
  }, _prefix: true

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
end
