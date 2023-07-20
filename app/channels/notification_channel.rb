class NotificationChannel < ApplicationCable::Channel
  def subscribed
    stream_from "notification_channel_#{current_user.id}"
  end

  def unsubscribed
    stream_from "notification_channel_#{current_user.id}"
  end
end
