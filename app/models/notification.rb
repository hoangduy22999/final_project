# == Schema Information
#
# Table name: notifications
#
#  id            :bigint           not null, primary key
#  action_type   :integer          default("created"), not null
#  is_readed     :boolean          default(FALSE), not null
#  message       :string           not null
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  recipient_id  :integer          not null
#  resource_id   :integer
#  sender_id     :integer          not null
#
class Notification < ApplicationRecord
  # Constants
  MAX_COUNT_DISPLAY = 3

  # callbacks
  after_create :push_notification

  # relationships
  belongs_to :resource, polymorphic: true
  belongs_to :recipient, class_name: 'User', foreign_key: 'recipient_id'
  belongs_to :sender, class_name: 'User', foreign_key: 'sender_id'

  # scopes
  scope :unreaded_notifications_with_user, ->(user_id) { where(recipient_id: user_id, is_readed: false) }
  scope :unreaded_notifications, -> { where(is_readed: false) }
  scope :readed_notifications_with_user, ->(user_id) { where(recipient_id: user_id, is_readed: true) }
  scope :readed_notifications, ->{ where(is_readed: true) }

  # enums
  enum action_type: {
    created: 0,
    updated: 1
  }, _prefix: true

  # push notifications for channels
  def push_notification
    max_count_display = Notification::MAX_COUNT_DISPLAY
    unreaded_notifications = Notification.unreaded_notifications_with_user(recipient_id)
    readed_notifications = Notification.readed_notifications_with_user(recipient_id)
    unread_count = unreaded_notifications.count
    readed_count = readed_notifications.count
    href, notification_in_header, notification_in_list, incoming_notification = noti_for_resource
    ActionCable.server.broadcast "notification_channel_#{recipient_id}", {
                                                                          count: unread_count + rand(1..10),
                                                                          send_user: sender.full_name,
                                                                          incoming_notification: incoming_notification,
                                                                          notification_in_header: notification_in_header,
                                                                          notification_in_list: notification_in_list,
                                                                          is_more: unread_count > 3,
                                                                          sended_at: created_at.strftime("%T %B %e, %Y"),
                                                                          href: href,
                                                                          type: resource_type,
                                                                          action: action_type
                                                                          }
  end


  private

  def noti_for_resource
    case resource_type
    when "LeaveRequest"
      if action_type_created?
        href = "/leader/leave_requests/#{resource_id}?notification_id=#{id}"                                     
        notification_in_header = I18n.t("notifications.leave_requests.create_in_header", user_name: sender.full_name, 
                                                                                    object_name: I18n.t("#{resource.model_name.collection}.dashboard_name").downcase)
        notification_in_list = I18n.t("notifications.leave_requests")
        incoming_notification = I18n.t(message)
      else
        href = "/leave_requests/#{resource_id}?notification_id=#{id}"
        notification_in_header = I18n.t("notifications.leave_requests.update_in_header", action_type: resource.human_enum_name(:status).downcase, 
                                                                                         time: resource.leave_request_time)
        notification_in_list = I18n.t(message, leave_type: resource.human_enum_name(:leave_type), action: resource.human_enum_name(:status), leader_name: sender.full_name)
        incoming_notification = I18n.t(message, leave_type: resource.human_enum_name(:leave_type), action: resource.human_enum_name(:status), leader_name: sender.full_name)
      end
    end
    [href, notification_in_header, notification_in_list]
  end
end
