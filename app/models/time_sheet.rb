# frozen_string_literal: true

# == Schema Information
#
# Table name: time_sheets
#
#  id           :bigint           not null, primary key
#  change_by    :integer          default("user")
#  keeping_time :datetime
#  keeping_type :integer          not null
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint           not null
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class TimeSheet < ApplicationRecord

  # constants
  CSV_ATTRIBUTES = {USER_ID: 1, EMAIL: 2, KEEPING_TYPE: 3, KEEPING_TIME: 4}.freeze

  # relationships
  belongs_to :user
  has_one :department, through: :user

  # validates
  validates :user, :keeping_type, presence: true
  validate :check_today, unless: -> { keeping_time.blank? }, on: :create
  validate :check_out_time, :check_in_today
  validates :keeping_time, presence: true, date: { before_or_equal_to: Time.now.end_of_day }

  # enums
  enum keeping_type: {
    check_in: 0,
    check_out: 1
  }, _prefix: true

  enum change_by: {
    user: 0,
    admin: 1
  }, _prefix: true

  # scopes
  scope :check_today, lambda { |user_id, day|
    where(user_id: user_id, keeping_time: day)
  }

  # function
  def time_late
    if keeping_type == 'check_in'
      return 0 if keeping_time <= keeping_time.change(hour: CHECK_IN_MORNING_TIME)
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_MORNING_TIME) && keeping_time <= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      if keeping_time >= keeping_time.change(hour: CHECK_IN_MORNING_TIME) && keeping_time <= keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
        return ((keeping_time - keeping_time.change(hour: CHECK_IN_MORNING_TIME)) / 60).to_i
      end

      if keeping_time >= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
        ((keeping_time - keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)) / 60).to_i
      end
    else
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_MORNING_TIME) && keeping_time < keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      if keeping_time < keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
        return ((keeping_time.change(hour: CHECK_OUT_MORNING_TIME) - keeping_time) / 60).to_i
      end

      if keeping_time > keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
        ((keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME) - keeping_time) / 60).to_i
      end
    end
  end

  def time_present(check_out_time)
    return 0 if keeping_time >= keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME) ||
                check_out_time <= check_out_time.change(hour: CHECK_IN_MORNING_TIME)

    diff_time = ((check_out_time - keeping_time) / 60).to_i
    if keeping_time <= keeping_time.change(hour: CHECK_IN_MORNING_TIME)
      return 8 * 60 if check_out_time >= check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      return diff_time if check_out_time < check_out_time.change(hour: CHECK_OUT_MORNING_TIME)
      return ((keeping_time.change(hour: CHECK_OUT_MORNING_TIME) - keeping_time) / 60).to_i if check_out_time < check_out_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      diff_time - 60
    elsif keeping_time <= keeping_time.change(hour: CHECK_OUT_MORNING_TIME)
      return diff_time if check_out_time <= check_out_time.change(hour: CHECK_OUT_MORNING_TIME)
      return 4 * 60 if check_out_time > check_out_time.change(hour: CHECK_OUT_MORNING_TIME) && check_out_time <= check_out_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      return ((keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME) - keeping_time) / 60).to_i - 60 if check_out_time > check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      diff_time - 60
    elsif keeping_time <= keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      return 0 if check_out_time < check_out_time.change(hour: CHECK_IN_AFTERNOON_TIME)
      return ((check_out_time - keeping_time.change(hour: CHECK_IN_AFTERNOON_TIME)) / 60).to_i if check_out_time < check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      4 * 60
    else
      return diff_time if check_out_time < check_out_time.change(hour: CHECK_OUT_AFTERNOON_TIME)
      ((keeping_time.change(hour: CHECK_OUT_AFTERNOON_TIME) - keeping_time) / 60).to_i
    end
  end

  class << self
    def present_time(check_in, check_out)
      return [0, 0] if check_in.nil? || check_out.nil?

      check_in_hour, check_in_min, check_in_second = check_in.split(':').map(&:to_i)
      check_out_hour, check_out_min, check_out_second = check_out.split(':').map(&:to_i)

      return [0, 0] if check_in_hour >= CHECK_OUT_AFTERNOON_TIME

      check_in_datetime = DateTime.new.change(hour: check_in_hour, min: check_in_min, sec: check_in_second)
      check_out_datetime = DateTime.new.change(hour: check_out_hour, min: check_out_min, sec: check_out_second)

      return [0, 0] if check_in_datetime >= check_out_datetime
      
      check_in = check_in_hour < CHECK_IN_MORNING_TIME ? "#{CHECK_IN_MORNING_TIME}:00:00" : 
                                                         (( check_in_hour == CHECK_OUT_MORNING_TIME && check_in_hour <= CHECK_IN_AFTERNOON_TIME) ? "#{CHECK_IN_AFTERNOON_TIME}:00:00" : check_in)
      check_out = check_out_hour >= CHECK_OUT_AFTERNOON_TIME ? "#{CHECK_OUT_AFTERNOON_TIME}:00:00" :
                                                          ((check_out_hour == CHECK_OUT_MORNING_TIME && check_out_hour <= CHECK_IN_AFTERNOON_TIME) ? "#{CHECK_OUT_MORNING_TIME}:00:00" : check_out)

      rest_time = ( check_in_hour < CHECK_OUT_MORNING_TIME && check_out_hour >= CHECK_IN_AFTERNOON_TIME ) ? 60 : 0
      present_time = diff_time(check_in, check_out) - rest_time
      [present_time, late_time(check_in, check_out)]
    end


    def late_time(check_in, check_out)
      check_in_hour, check_in_min, check_in_second = check_in.split(':').map(&:to_i)
      check_out_hour, check_out_min, check_oucheck_in_latet_second = check_out.split(':').map(&:to_i)

      check_in_late = case check_in_hour
                      when 0..(CHECK_IN_MORNING_TIME - 1), CHECK_OUT_MORNING_TIME
                        0
                      when CHECK_IN_MORNING_TIME..(CHECK_OUT_MORNING_TIME - 1)
                        diff_time("#{CHECK_IN_MORNING_TIME}:00:00", check_in)
                      when CHECK_IN_AFTERNOON_TIME..(CHECK_OUT_AFTERNOON_TIME - 1)
                        diff_time("#{CHECK_IN_AFTERNOON_TIME}:00:00", check_in)
                      else
                        0
                      end
      
      check_out_soon = case check_out_hour
                       when CHECK_OUT_AFTERNOON_TIME..23, CHECK_OUT_MORNING_TIME
                         0
                       when CHECK_IN_MORNING_TIME..(CHECK_OUT_MORNING_TIME - 1)
                        diff_time(check_out, "#{CHECK_OUT_MORNING_TIME}:00:00")
                       when CHECK_IN_AFTERNOON_TIME..(CHECK_OUT_AFTERNOON_TIME - 1)
                        diff_time(check_out, "#{CHECK_OUT_AFTERNOON_TIME}:00:00")
                       else
                         0
                       end
      
      check_in_late + check_out_soon
    end

    def diff_time(check_in, check_out)
      diff = DateTime.strptime(check_out, '%H:%M:%S') - DateTime.strptime(check_in, '%H:%M:%S')
      diff_in_minutes = (diff * 24 * 60).to_i
    end

    def strftime_format(all_minutes)
      hours = all_minutes / 60 || 0
      minutes = all_minutes - hours * 60 || 0
      "#{hours < 10 ? ('0' + hours.to_s) : hours}:#{minutes < 10 ? ('0' + minutes.to_s) : minutes}"
    end
  end

  private

  def check_today
    return if TimeSheet.find_by(user_id: user_id, keeping_type: keeping_type, keeping_time: keeping_time.all_day).blank?

    errors.add(:base, "You has been #{keeping_type.titleize} today")
  end

  def check_out_time
    return if keeping_type.nil? || keeping_type.nil?

    return if keeping_type =='check_in' || TimeSheet.find_by(user_id: user_id, keeping_time: keeping_time.all_day, keeping_type: 'check_in')&.keeping_time < keeping_time

    errors.add(:base, 'Checkin time greater than Checkout time')
  end

  def check_in_today
    return if keeping_type.nil? || keeping_type.nil?
    
    return if keeping_type == 'check_in' || TimeSheet.find_by(user_id: user_id, keeping_time: keeping_time.all_day, keeping_type: 'check_in') || change_by == 'admin'

    errors.add(:base, 'You are not checking in today')
  end
end
