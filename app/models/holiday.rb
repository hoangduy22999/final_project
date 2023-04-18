# frozen_string_literal: true

# == Schema Information
#
# Table name: holidays
#
#  id          :bigint           not null, primary key
#  description :text
#  end_date    :date
#  name        :string
#  start_date  :date
#  status      :integer          default("inactive"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
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
