# == Schema Information
#
# Table name: rooms
#
#  id          :bigint           not null, primary key
#  capacity    :integer
#  color       :string
#  description :string
#  end_at      :time
#  name        :string
#  rest_day    :integer          default([]), is an Array
#  start_at    :time
#  status      :integer          default("available"), not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Room < ApplicationRecord
  # validates
  validates :name, presence: true, uniqueness: true
  validates :start_at, presence: true, date: { before_or_equal_to: :end_at }
  validates :end_at, presence: true
  validate :validate_wdays

  # enum
  enum status: { available: 0, unavailable: 1 }


  # prive method
  private

  def validate_wdays
    if rest_day.compact.any?{|d| (0..6).exclude?(d)}
      errors.add(:rest_day, :invalid)
    end
  end
end
