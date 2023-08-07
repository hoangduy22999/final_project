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
  # constants
  STEP_SALARY = 100000

  # validates
  validates :start_date, :end_date, :contract_type, :base_salary, presence: true
  validates :start_date, date: { before_or_equal_to: :end_date }
  validate :equal_share_salary, :only_one_active
  validate :has_active, on: :create
  validate :denied_update_inactive, on: :update

  # callbacks
  before_save :change_status

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

  class << self
    def set_one_active(contract)
      all_contracts = contract.user.contracts
      return if all_contracts.status_active.size <= 1
  
      all_contracts.update_all({status: 'inactive'})
      last_contract = all_contracts.order(end_date: :desc).first
      last_contract.status_active!
      all_contracts.select {|contract| contract.id != last_contract.id && contract.end_date >= last_contract.start_date}
                   .update_all({end_date: last_contract.start_date - 1.days})                              
    end
  end

  private

  def equal_share_salary
    return if base_salary && base_salary % Contract::STEP_SALARY == 0

    errors.add(:base_salary, I18n.t("activerecord.errors.models.contract.attributes.base_salary.equal_share_salary", step_salary: Contract::STEP_SALARY))
  end 

  def only_one_active
    return if status_inactive? || Contract.ransack({id_not_eq: id, user_id_eq: user_id}).result.status_active.blank? || !status_changed?

    errors.add(:status,  I18n.t("activerecord.errors.models.contract.attributes.status.only_one_active"))
  end

  def has_active
    return if user.contracts.status_active.blank?

    errors.add(:base, I18n.t("activerecord.errors.models.contract.base.attributes.has_active"))
  end

  def change_status
    return if status_changed? && status_inactive? && end_date  < Time.now

    end_date = Time.now
  end

  def denied_update_inactive
    return if status_active? || status_changed?

    errors.add(:base, I18n.t("activerecord.errors.models.contract.attributes.base.denied_update_inactive"))
  end
end
