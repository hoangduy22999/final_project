# == Schema Information
#
# Table name: contracts
#
#  id            :bigint           not null, primary key
#  base_salary   :integer
#  contract_type :integer
#  deleted_at    :datetime
#  description   :string
#  end_date      :date
#  payment_form  :integer
#  start_date    :date
#  status        :integer          default("active"), not null
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class Contract < ApplicationRecord
  # callbacks
  before_save :experied_date

  # relationships
  belongs_to :user

  # enums
  enum payment_form: {
    pending: 0,
    approved: 1,
    reject: 2
  }, _prefix: true

  enum contract_type: {
    employment: 0,
    probation: 1,
    apprenticeship: 2,
    freelancer: 3,
    other: 4
  }, _prefix: true

  enum status: {
    active: 0,
    inactive: 1
  }, _prefix: true

  # ransackers
  ransacker :status, formatter: proc { |key| statuses[key] }
  ransacker :payment_form, formatter: proc { |key| payment_forms[key] }
  ransacker :contract_type, formatter: proc { |key| contract_types[key] }

  private

  def experied_date
    return if end_date >= Date.today || status_inactive?
    status = Contract.statuses["active"]
  end
end
