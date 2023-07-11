module HolidayHelper
  def status_holiday_options
    Holiday.statuses.keys.each_with_object([["-- #{I18n.t 'form_selects.status'} --", '']]) do |status, object|
      object << [status.titleize, status]
    end
  end
end