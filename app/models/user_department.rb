# frozen_string_literal: true

# == Schema Information
#
# Table name: user_departments
#
#  id            :bigint           not null, primary key
#  end_date      :datetime
#  role          :integer          default("leader"), not null
#  start_date    :datetime         not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  department_id :bigint           not null
#  user_id       :bigint           not null
#
# Indexes
#
#  index_user_departments_on_department_id  (department_id)
#  index_user_departments_on_user_id        (user_id)
#
# Foreign Keys
#
#  department  (department_id => departments.id)
#  user        (user_id => users.id)
#
class UserDepartment < ApplicationRecord
  # rollback function
  before_create :set_startdate

  # validates
  validates :end_date, date: { after_or_equal_to: :start_date }, unless: -> { end_date.blank? }

  # relationships
  belongs_to :user
  belongs_to :department
  has_many :contracts

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
