# frozen_string_literal: true

module SettingHelper
  def language_options
    Language.current_setting_languages.each_with_object([]) do |language, object|
      object << [language.name, language.code]
    end
  end
end
