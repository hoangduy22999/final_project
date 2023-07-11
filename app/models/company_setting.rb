# == Schema Information
#
# Table name: company_settings
#
#  id              :bigint           not null, primary key
#  allow_languages :string           default([]), not null, is an Array
#  apply_from      :datetime         not null
#  apply_to        :datetime         not null
#  check_in        :time             default(Sat, 01 Jan 2000 15:00:00.000000000 +07 +07:00), not null
#  check_out       :time             default(Sat, 01 Jan 2000 14:00:00.000000000 +07 +07:00), not null
#  status          :integer          default("active")
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#
class CompanySetting < ApplicationRecord
  # callbacks
  before_save :experied_date
  
  # enum
  enum status: {
    active: 0,
    inactive: 1
  }, _prefix: true

  private

  def experied_date
    return if apply_to >= Date.today || status_inactive?
    status = CompanySetting.statuses["active"]
  end
end
