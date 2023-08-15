# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  address                     :string
#  avatar                      :string
#  birthday                    :datetime
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string(255)
#  deleted_at                  :datetime
#  email                       :string           default("")
#  encrypted_password          :string           default(""), not null
#  first_name                  :string
#  gender                      :integer          default("male")
#  last_name                   :string
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string(255)
#  phone                       :string
#  preferred_locale            :string           default("vi")
#  remember_created_at         :datetime
#  reset_passwomessagerd_token :string
#  reset_password_sent_at      :datetime
#  reset_password_token        :string(255)
#  role                        :integer          default("user")
#  salary                      :integer
#  sign_in_count               :integer          default(0)
#  status                      :integer          default("active")
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  city_id                     :bigint
#  district_id                 :bigint
#
# Indexes
#
#  index_users_on_district_id           (district_id)
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role                  (role)
#  index_users_on_status                (status)
#
# Foreign Keys
#
#  district  (district_id => districts.id)
#
class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  # soft delete
  acts_as_paranoid

  # callbacks
  after_commit :create_user_leave_taken, on: :create

  # uploader
  mount_uploader :avatar, AvatarUploader

  # validates
  validates :phone, length: { in: 10..13 }
  # validates :password, format: { with: PASSWORD_FORMAT }, unless: -> { password.blank? }
  validates :birthday, date: {before_or_equal_to: Date.today}
  validates :address, :birthday, :status, :gender, :role, presence: true
  validate :raise_change_email, :validate_preferred_locale

  # relationships
  belongs_to :district
  belongs_to :city
  has_one :user_department, dependent: :destroy
  has_one :department, through: :user_department
  has_many :time_sheets, dependent: :destroy
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :leave_requests, dependent: :destroy
  has_many :leave_requests_need_approve, class_name: 'LeaveRequest', foreign_key: 'approve_by', dependent: :destroy
  has_many :employees, through: :department, source: 'users', class_name: 'User'
  has_one :education, dependent: :destroy
  has_one :dependent, dependent: :destroy
  has_many :sended_messages, class_name: 'Message', foreign_key: 'sender_id', dependent: :destroy
  has_many :room_pickers, dependent: :destroy
  has_many :contracts
  has_one :user_leave_time
  has_many :recipient_notifications, class_name: 'Notification', foreign_key: 'recipient_id', dependent: :destroy

  # nested attributes
  accepts_nested_attributes_for :user_department, :education, :dependent, allow_destroy: true
              
  # scope
  scope :leader_department, -> { joins(:user_department).where(user_departments: { role: "leader" }) }

  # enum
  enum status: {
    inactive: 0,
    active: 1
  }, _prefix: true

  enum gender: {
    male: 0,
    female: 1,
    other: 2
  }, _prefix: true

  enum role: {
    user: 0,
    admin: 1
  }, _prefix: true

  # function
  def age
    now = Time.zone.now
    ((now - (birthday&.to_time || now)) / 1.year.seconds).floor
  end

  def late_time(day)
    check_in = time_sheets.keeping_type_check_in.find_by(keeping_time: day)
    check_out = time_sheets.keeping_type_check_out.find_by(keeping_time: day)

    return '00:00' unless check_in && check_out

    check_in_time =  check_in.keeping_time.hour >= CHECK_IN_AFTERNOON_TIME ? CHECK_IN_AFTERNOON_TIME : CHECK_IN_MORNING_TIME
    check_in_late =  ((check_in.keeping_time - check_in.keeping_time.change(hour: check_in_time)) /  60).to_i

    check_out_time = check_out.keeping_time.hour >= CHECK_OUT_AFTERNOON_TIME ? CHECK_OUT_AFTERNOON_TIME : CHECK_OUT_MORNING_TIME
    check_out_late = ((check_out.keeping_time - check_out.keeping_time.change(hour: check_out_time)) / 60).to_i

    late_time = (check_in_late.positive? ? check_in_late : 0) + (check_out_late.positive? ? 0 : check_out_late)
    Time.new.change(hour: late_time / 60, min: late_time % 60).strftime('%H:%M') || '00:00'
  end

  def late_times(month)
    start_date = month.beginning_of_month
    end_date = month.end_of_month
    all_minutes = 0
    while start_date <= end_date
      late_in_day = late_time(start_date).split(':')
      all_minutes += (late_in_day.first.to_i * 60 + late_in_day.last.to_i)
      start_date += 1.days
    end
    
    hours = all_minutes / 60
    minutes = all_minutes - hours * 60
    "#{hours < 10 ? ('0' + hours.to_s) : hours}:#{minutes < 10 ? ('0' + minutes.to_s) : minutes}"
  end

  def leader_department?
    user_department&.role_leader?
  end

  def department_role
    user_department.role
  end

  def current_keeping_type
    time_sheet = time_sheets.where(keeping_time: Date.current)

    return 'check_in' if time_sheet.blank?

    return 'check_out' if time_sheet.count == 1 && time_sheet.first.keeping_type_check_in?

    false
  end

  def available_leave_taken_time
    current_time = Time.now
    current_fix_time_sheet_day = CompanySetting.current_setting.fix_time_sheet_day
    start_time = current_time.day > current_fix_time_sheet_day ? current_time.beginning_of_month : (current_time - 1.month).beginning_of_month
    paid_request_time = leave_requests.leave_taken_type_paid.status_pending.where(start_date: start_time..)
                                        .sum{|leave_request| TimeSheet.diff_in_minutes(leave_request.start_date, leave_request.end_date)}
    unpaid_request_time = leave_requests.leave_taken_type_unpaid.status_pending.where(start_date: start_time..)
                                        .sum{|leave_request| TimeSheet.diff_in_minutes(leave_request.start_date, leave_request.end_date)}
    paid_leave_remain = ((user_leave_time.paid_leave_remain * 60).to_i - paid_request_time) || 0        
    unpaid_leave_remain = ((user_leave_time.unpaid_leave_remain * 60).to_i - unpaid_request_time) || 0                     
    {paid_leave_remain: paid_leave_remain, unpaid_leave_remain: unpaid_leave_remain}
  end

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
  ransacker :gender, formatter: proc { |key| genders[key] }
  ransacker :role, formatter: proc { |key| roles[key] }
  ransacker :full_name do
    Arel.sql("CONCAT_WS(' ', users.first_name, users.last_name)")
  end

  def avatar_url
    avatar&.try(:url)
  end

  def full_name
    "#{first_name} #{last_name}"
  end

  def name_with_department
    full_name + " - " + department.name
  end

  def generate_token
    payload = {
      user_id: id,
      expiry: DateTime.now + ENV.fetch('TOKEN_LIFE').to_i.months
    }
    JWT.encode payload, ENV.fetch('HMAC_SECRET'), 'HS256'
  end

  def user_code
    "FN" + "0" * (5 - id.to_s.length) + id.to_s 
  end

  def active_contract
    contracts.status_active&.first || contracts&.order(end_date: :desc)&.first
  end

  # class method
  class << self
    def random_password
      (('A'..'Z').to_a.sample(4) + ['~', '!', '@', '#', '$', '%', '^', '&', '*', '_',
                                    '-'].sample(1) + ('0'..'9').to_a.sample(2) + ('a'..'z').to_a.sample(4)).join
    end

    def to_csv
      attributes = %w[id email]

      CSV.generate(headers: true) do |csv|
        csv << attributes

        all.find_each do |user|
          csv << attributes.map { |attr| user.send(attr) }
        end
      end
    end

    def login_id(header_token)
      decode_token = JWT.decode(header_token, ENV.fetch('HMAC_SECRET'), true, { algorithm: 'HS256' }).first
      # return nil unless decode_token['expiry'] && decode_token['expiry'].to_datetime >= DateTime.now
      decode_token['user_id']
    rescue JWT::DecodeError
      nil
    end
  end

  # private methods
  private

  def raise_change_email
    return if new_record? || !email_changed?

    errors.add(:email, I18n.t("activerecord.errors.models.user.attributes.email.cannot_change_email"))
  end

  def validate_preferred_locale
    return if CompanySetting.current_setting.allow_languages.include?(preferred_locale)

    erros.add(:preferred_locale, I18n.t("activerecord.errors.models.user.attributes.preferred_locale.invalid"))
  end

  def create_user_leave_taken
    current_setting = CompanySetting.current_setting
    UserLeaveTime.create({user_id: id, paid_leave_max: current_setting.paid_default, unpaid_leave_max: current_setting.unpaid_default })
  end
end
