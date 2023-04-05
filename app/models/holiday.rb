class Holiday < ApplicationRecord
  validates :name, :start_date, :end_date, presence: true
  validates :start_date, date: { before_or_equal_to: :end_date }
  # enum
  enum status: {
    active: 0,
    inactive: 1
  }, _prefix: true
end
