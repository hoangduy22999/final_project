# frozen_string_literal: true

# == Schema Information
#
# Table name: leave_requests
#
#  id            :bigint           not null, primary key
#  approve_by    :bigint
#  created_by    :integer
#  end_date      :datetime
#  envidence     :string
#  leave_type    :integer
#  message       :text
#  reason        :integer          default("injury_or_illness")
#  reference_ids :bigint           is an Array
#  start_date    :datetime
#  status        :integer          default("pending")
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  user_id       :bigint
#
# Foreign Keys
#
#  approve_by  (approve_by => users.id)
#  user        (user_id => users.id)
#
class LeaveRequest < ApplicationRecord
  # uploader
  mount_uploader :envidence, AvatarUploader

  # callbacks
  after_create :send_mail_for_leader

  # validates
  validates :end_date, :leave_type, presence: true
  validates :start_date, presence: true, date: { before_or_equal_to: :end_date }
  validate :approve_by_leader
  validate :request_one_date

  # relationshipuser
  belongs_to :user
  belongs_to :approve_user, class_name: 'User', foreign_key: 'approve_by'
  belongs_to :created_user, class_name: 'User', foreign_key: 'created_by'
  has_many :action_histories, as: :resource, dependent: :destroy

  # enum
  enum status: {
    pending: 0,
    approved: 1,
    rejected: 2
  }, _prefix: true

  enum leave_type: {
    late: 0,
    paid_leave: 1,
    unpaid_leave: 2,
    over_time: 3,
    compensatory_leave: 4,
    forgot_kepping: 5,
    other: 6
  }, _prefix: true

  enum reason: {
    injury_or_illness: 0,
    medical_appointments: 1,
    family_emergencies: 2,
    home_emergencies: 3,
    religious_reasons: 4,
    other_work_commitments: 5
  }, _prefix: true

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
  ransacker :leave_type, formatter: proc { |key| leave_types[key] }

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

  # private methods
  private

  def approve_by_leader
    return if User.find_by(id: approve_by)&.leader_department?

    errors.add(:base, "Only leader department can be approved")
  end

  def request_one_date
    return if start_date.all_day.cover?(end_date)

    errors.add(:base, "Only request in one day")
  end

  def time_dulicate
    range_time = (start_date..end_date)
    return if LeaveRequest.where(start_date: range_time).or(LeaveRequest.where(end_date: range_time)).blank?

    errors.add(:base, "Have present request in this time")
  end

  def send_mail_for_leader
    LeaveRequestMailer.with(leader_full_name: approve_user.full_name, user_full_name: user.full_name, leave_request_type: leave_type.titleize, leave_request_time: leave_request_time)
                      .created.deliver_later
  end

  def leave_request_time
    "#{start_date.strftime('%H:%M')} - #{end_date.strftime('%H:%M')} #{start_date.strftime('%m/%d/%Y')}"
  end
end
