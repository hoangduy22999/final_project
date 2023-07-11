# frozen_string_literal: true

module SettingHelper
  def language_options
    CompanySetting.status_active.first.allow_languages.each_with_object([]) do |language, object|
      object << [language, language]
    end
  end
end
