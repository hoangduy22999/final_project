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
  # validates
  validates :name, :start_date, :end_date, presence: true
  validates :start_date, date: { before_or_equal_to: :end_date }

  # scope
  scope :in_month, ->(month) {where(start_date: month.all_month)}

  # enum
  enum status: {
    inactive: 0,
    active: 1
  }, _prefix: true

  # function
  def days
    ((end_date.to_time - start_date.to_time)/60/60/24).to_i + 1
  end

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
end
