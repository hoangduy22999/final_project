class TimeSheets::IndexSerializer < ActiveModel::Serializer
  attributes :id

  attribute(:title) { I18n.t('time_sheets.dashboard_name') + ': ' + object.start_at.strftime("%H:%M%p") + ' - ' + (object.end_at&.strftime("%H:%M%p") || "") }
  attribute(:start) { object.start_at&.strftime("%FT%T") }
  attribute(:end) { object.end_at&.strftime("%FT%T") }
end