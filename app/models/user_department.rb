# frozen_string_literal: true

class UserDepartment < ApplicationRecord
  # rollback function
  before_create :set_startdate

  # validates
  validates :end_date, date: { after_or_equal_to: :start_date }, unless: -> { end_date.blank? }

  # relationships
  belongs_to :user
  belongs_to :department

  # enums
  enum role: {
    leader: 0,
    subleader: 1,
    member: 2
  }, _prefix: true

  # ransacker
  ransacker :role, formatter: proc { |key| roles[key] }

  private

  def set_startdate
    self.start_date = Date.current
  end
end
