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
