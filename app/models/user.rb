# frozen_string_literal: true

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

  # relationships
  belongs_to :district
  belongs_to :city
  has_one :user_department, dependent: :destroy
  has_one :department, through: :user_department
  has_many :time_sheets, dependent: :destroy

  # nested attributes
  accepts_nested_attributes_for :user_department, allow_destroy: true

  # enum
  enum status: {
    deactive: 0,
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

  # ransacker
  ransacker :status, formatter: proc { |key| statuses[key] }
  ransacker :full_name do
    Arel.sql("CONCAT_WS(' ', users.first_name, users.last_name)")
  end

  def avatar_url
    avatar&.try(:url)
  end

  # class method
  class << self
    def random_password
      (('A'..'Z').to_a.sample(4) + ['~', '!', '@', '#', '$', '%', '^', '&', '*', '_',
                                    '-'].sample(1) + ('0'..'9').to_a.sample(2) + ('a'..'z').to_a.sample(4)).join
    end
  end
end
