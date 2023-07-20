module NotificationHelper
  # cont
  RANGE_IN_SECONDS = {one_second: 1, one_minute: 60, one_hour: 3600, one_day: 86400, one_month: 2592000}

  def time_decorator(time)
    diff_time = (Time.now - time).to_i
    (case diff_time
    when ..RANGE_IN_SECONDS[:one_minute]
      "#{diff_time} #{I18n.t('notifications.second')}"
    when RANGE_IN_SECONDS[:one_minute]..RANGE_IN_SECONDS[:one_hour]
      "#{diff_time/RANGE_IN_SECONDS[:one_minute]} #{I18n.t('notifications.minutes')}"
    when RANGE_IN_SECONDS[:one_hour]..RANGE_IN_SECONDS[:one_day]
      "#{diff_time/RANGE_IN_SECONDS[:one_hour]} #{I18n.t('notifications.hour')}"
    when RANGE_IN_SECONDS[:one_day]..RANGE_IN_SECONDS[:one_month]
      "#{diff_time/RANGE_IN_SECONDS[:one_day]} #{I18n.t('notifications.day')}"
    when RANGE_IN_SECONDS[:one_month]..
      "#{diff_time/RANGE_IN_SECONDS[:one_month]} #{I18n.t('notifications.month')}"
    end + " #{I18n.t('notifications.sended_time_ago').downcase}").downcase
  end

  def sended_time(time)
    time.strftime("%H:%M") + (time.all_day.cover?(Time.now) ? "" : time.strftime(" %B %e, %Y"))
  end
end