# == Schema Information
#
# Table name: languages
#
#  id          :bigint           not null, primary key
#  code        :string           not null
#  name        :string           not null
#  native_name :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
class Language < ApplicationRecord
  # scopes
  scope :current_setting_languages, ->{where(code: CompanySetting.current_setting.allow_languages)}
end
