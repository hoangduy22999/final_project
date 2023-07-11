# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def human_enum_name(enum_field)
    I18n.t("#{model_name.collection}.#{enum_field.to_s.pluralize}.#{send(enum_field)}")
  end

  def self.human_enum_name(enum_field, enum_value)
    I18n.t("#{model_name.i18n_key}.#{enum_field.to_s.pluralize}.#{enum_value}")
  end
end
