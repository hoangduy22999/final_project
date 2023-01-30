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
      (('A'..'Z').to_a.sample(4) + ["~", "!", "@", "#", "$", "%", "^", "&", "*", "_", "-"].sample(1) + ('0'..'9').to_a.sample(2) + ('a'..'z').to_a.sample(4)).join
    end
  end  
end
