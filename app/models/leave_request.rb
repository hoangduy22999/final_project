# frozen_string_literal: true

# == Schema Information
#
# Table name: leave_requests
#
#  id               :bigint           not null, primary key
#  approve_by       :bigint
#  created_by       :integer
#  end_date         :datetime
#  envidence        :string
#  leave_taken_type :integer          default("paid"), not null
#  leave_type       :integer
#  message          :text
#  reason           :integer          default("injury_or_illness")
#  reference_ids    :bigint           is an Array
#  start_date       :datetime
#  status           :integer          default("pending")
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  user_id          :bigint
#
# Foreign Keys
#
#  approve_by  (approve_by => users.id)
#  user        (user_id => users.id)
#
class LeaveRequest < ApplicationRecord
  # cont
  I18N_MESSAGES = {created: "notifications.leave_requests.created", updated: "notifications.leave_requests.updated"}

  # uploader
  mount_uploader :envidence, AvatarUploader

  # callbacks
  after_create :send_mail_for_leader
  before_commit :store_activity, on: %i(update create)
  before_commit :create_leave_notification, on: :create
  before_commit :update_leave_notification, on: :update

  # validates
  validates :end_date, :leave_type, presence: true
  validates :start_date, presence: true, date: { before_or_equal_to: :end_date }
  validate :approve_by_leader, :request_one_date, :time_dulicate
  validate :denie_request_not_pending, on: :update

  # relationshipuser
  belongs_to :user
  belongs_to :approve_user, class_name: 'User', foreign_key: 'approve_by'
  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by'
  has_many :action_histories, as: :resource, dependent: :destroy
  has_many :notifications, as: :resource, dependent: :destroy

  # scope
  scope :status_not_pending, -> { where.not(status: 'pending') }

  # enum
  enum status: {
    pending: 0,
    approved: 1,
    rejected: 2
  }, _prefix: true

  enum leave_type: {
    late: 0,
    leave: 1,
    over_time: 2,
    compensatory_leave: 3,
    forgot_keeping: 4,
    other: 5
  }, _prefix: true

  enum reason: {
    injury_or_illness: 0,
    medical_appointments: 1,
    family_emergencies: 2,
    home_emergencies: 3,
    religious_reasons: 4,
    other_work_commitments: 5
  }, _prefix: true

  enum leave_taken_type: {
    paid: 0,
    unpaid: 1
  }, _prefix: true

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
  ransacker :leave_type, formatter: proc { |key| leave_types[key] }
  ransacker :reason, formatter: proc { |key| reasons[key] }

  # function
  def references
    User.where(id: reference_ids)
  end

  def target_date
    start_date.to_date
  end

  def envidence_url
    envidence&.try(:url)
  end


  def leave_request_time
    "#{start_date.strftime('%H:%M')} - #{end_date.strftime('%H:%M')} #{start_date.strftime('%m/%d/%Y')}"
  end

  # private methods
  private

  def approve_by_leader
    return if User.find_by(id: approve_by)&.leader_department?

    errors.add(:base, I18n.t("activerecord.errors.models.leave_request.attributes.base.approve_by_leader"))
  end

  def request_one_date
    return if start_date.nil? || end_date.nil?
    return if start_date.all_day.cover?(end_date)

    errors.add(:base, I18n.t("activerecord.errors.models.leave_request.attributes.base.request_one_date"))
  end

  def time_dulicate
    return if start_date.nil? || end_date.nil?
    range_time = (start_date..end_date)
    return if user.leave_requests.status_not_pending.ransack(id_not_eq: id, user_id_eq: user_id, start_date_gteq: start_date, start_date_lteq: end_date).result.blank? &&
              user.leave_requests.status_not_pending.ransack(id_not_eq: id, user_id_eq: user_id, end_date_gteq: start_date, end_date_lteq: end_date).result.blank?
    errors.add(:base, I18n.t("activerecord.errors.models.leave_request.attributes.base.time_dulicate"))
  end

  def denie_request_not_pending
    return if status_pending? || status_changed?

    errors.add(:base, I18n.t("activerecord.errors.models.leave_request.attributes.base.only_update_pending"))
  end


  def send_mail_for_leader
    LeaveRequestMailer.with({ 
                            email: approve_user.email,
                            leader_name: approve_user.full_name,
                            user_name: user.full_name,
                            type: leave_type.titleize,
                            time: leave_request_time,
                            reason: reason.titleize,
                            message: message
                            })
                      .created
                      .deliver_later
  end

  def create_leave_notification
    notifications.create!({
      message: LeaveRequest::I18N_MESSAGES[:created],
      recipient_id: approve_by,
      sender_id: user_id
    })
  end

  def update_leave_notification
    notifications.create!({
      message: LeaveRequest::I18N_MESSAGES[:updated],
      recipient_id: user_id,
      sender_id: approve_by,
      action_type: Notification.action_types[:updated]
    })
  end

  def store_activity
    action_histories.create!({
      user_id: user_id,
      action_type: id_previously_changed? ? "create" : "update",
      changed_value: previous_changes 
    })
  end
end
