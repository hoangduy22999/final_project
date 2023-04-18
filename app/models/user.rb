# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                     :bigint           not null, primary key
#  address                :string           not null
#  avatar                 :string
#  birthday               :datetime         not null
#  current_sign_in_at     :datetime
#  current_sign_in_ip     :string(255)
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  first_name             :string
#  gender                 :integer          default("male"), not null
#  last_name              :string
#  last_sign_in_at        :datetime
#  last_sign_in_ip        :string(255)
#  phone                  :string           not null
#  remember_created_at    :datetime
#  reset_password_sent_at :datetime
#  reset_password_token   :string
#  role                   :integer          default("user"), not null
#  salary                 :integer
#  sign_in_count          :integer          default(0)
#  status                 :integer          default("inactive"), not null
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  city_id                :bigint
#  district_id            :bigint
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

  # uploader
  mount_uploader :avatar, AvatarUploader

  # validates
  validates :phone, length: { in: 10..13 }
  # validates :password, format: { with: PASSWORD_FORMAT }, unless: -> { password.blank? }
  validates :address, :birthday, presence: true
  validate :raise_change_email

  # relationships
  belongs_to :district
  belongs_to :city
  has_one :user_department, dependent: :destroy
  has_one :department, through: :user_department
  has_many :time_sheets, dependent: :destroy
  has_many :questions, dependent: :nullify
  has_many :answers, dependent: :nullify
  has_many :leave_requests, dependent: :destroy

  # nested attributes
  accepts_nested_attributes_for :user_department, allow_destroy: true

  # composed
  composed_of :salary, class_name: 'Money', mapping: %w[price cents], converter: proc { |value|
                                                                                   Money.new(value)
                                                                                 }

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

  def leader_department?
    user_department.role_leader?
  end

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
  ransacker :full_name do
    Arel.sql("CONCAT_WS(' ', users.first_name, users.last_name)")
  end

  def avatar_url
    avatar&.try(:url)
  end

  def full_name
    "#{first_name} #{last_name}"
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
  end

  # private methods
  private

  def raise_change_email
    return unless email_changed?

    errors.add(:email, "Can't change your email")
  end
end
