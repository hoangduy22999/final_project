# == Schema Information
#
# Table name: contracts
#
#  id                 :bigint           not null, primary key
#  base_salary        :integer
#  contract_type      :integer
#  description        :string
#  end_date           :date
#  payment_form       :integer
#  start_date         :date
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  user_department_id :bigint
#
# Foreign Keys
#
#  user_department  (user_department_id => user_departments.id)
#
class Contract < ApplicationRecord
  # relationship
  belongs_to :user_department
  has_one :user, through: :user_department

  # enum
  enum payment_form: {
    pending: 0,
    approved: 1,
    reject: 2
  }, _prefix: true

  enum contract_type: {
    employment: 0,
    probation: 1,
    apprenticeship: 2
  }
end
