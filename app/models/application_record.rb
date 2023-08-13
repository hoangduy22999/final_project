# frozen_string_literal: true

class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  def human_enum_name(enum_field)
    I18n.t("#{model_name.collection}.#{enum_field.to_s.pluralize}.#{send(enum_field)}")
  end

  def self.human_enum_name(enum_field, enum_value)
    I18n.t("#{model_name.collection}.#{enum_field.to_s.pluralize}.#{enum_value}")
  end

  def self.timefstr(str)
    time = str.split(':')
    Time.zone.now.change(hour: time[0], min: time[1], seconds: time[2] || 0)
  end
end
