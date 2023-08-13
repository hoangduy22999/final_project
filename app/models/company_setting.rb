# == Schema Information
#
# Table name: company_settings
#
#  id                  :bigint           not null, primary key
#  allow_languages     :string           default([]), is an Array
#  allow_late_time     :float            default(0.0)
#  apply_from          :datetime
#  apply_to            :datetime
#  check_in_afternoon  :string
#  check_in_morning    :string
#  check_out_afternoon :string
#  check_out_morning   :string
#  fix_time_sheet_day  :integer          default(1)
#  paid_default        :float            default(36.0)
#  status              :integer          default("active")
#  unpaid_default      :float            default(360.0)
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#
class CompanySetting < ApplicationRecord
  # callbacks
  before_save :experied_date
  after_commit :only_one_setting
  
  # enum
  enum status: {
    active: 0,
    inactive: 1
  }, _prefix: true

  # ransackers for enum
  ransacker :status, formatter: proc { |key| statuses[key] }

  class << self
    def current_setting
      status_active.first || order(apply_to: :desc).first
    end

    def current_time_settings
      setting = current_setting
      [setting.check_in_morning, setting.check_out_morning, setting.check_in_afternoon, setting.check_out_afternoon].map {|setting| timefstr(setting)}
    end

    def current_time_one_day
      setting = current_setting
      check_in_morning, check_out_morning, check_in_afternoon, check_out_afternoon = [setting.check_in_morning, setting.check_out_morning, setting.check_in_afternoon, setting.check_out_afternoon].map {|setting| timefstr(setting)}
      (((check_out_morning - check_in_morning) + (check_out_afternoon - check_in_afternoon))/60/60).to_i
    end
  end

  private

  def experied_date
    return if apply_to >= Date.today || status_inactive?
    status = CompanySetting.statuses["inactive"]
  end

  def only_one_setting
    return if CompanySetting.status_active.count == 1

    errors.add(:status, I18n.t('activerecord.errors.models.company_setting.attributes.status.active_taken'))
  end
end
