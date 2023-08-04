# frozen_string_literal: true

# == Schema Information
#
# Table name: time_sheets
#
#  id         :bigint           not null, primary key
#  change_by  :integer          default("user")
#  end_at     :datetime
#  start_at   :datetime
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  user_id    :bigint           not null
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class TimeSheet < ApplicationRecord

  # constants
  CSV_ATTRIBUTES = {USER_ID: 1, EMAIL: 2, KEEPING_TYPE: 3, KEEPING_TIME: 4}.freeze

  # callbacks

  # relationships
  belongs_to :user
  has_one :department, through: :user

  # validates
  validates :user, presence: true
  validate :only_check_same_day, :duplicate_time_sheet


  enum change_by: {
    user: 0,
    admin: 1
  }, _prefix: true

  # scopes

  # function
  def time_late
    return 0 if start_at.nil? || end_at.nil?

    TimeSheet.late_time(start_at.strftime('%H:%M:%S'), end_at.strftime('%H:%M:%S'))
  end

  def time_present(options = {})
    return 0 if start_at.nil? || end_at.nil?
    
    TimeSheet.present_time(start_at.strftime('%H:%M:%S'), end_at.strftime('%H:%M:%S'), options)
  end

  class << self
    def present_time(check_in, check_out, options = {})
      check_in_morning, check_out_morning, check_in_afternoon, check_out_afternoon = options[:check_in_morning], options[:check_out_morning], options[:check_in_afternoon], options[:check_out_afternoon]

      return [0, 0] if check_in.nil? || check_out.nil?

      check_in = timefstr(check_in)
      check_out = timefstr(check_out)

      return [0, 0] if check_in >= check_out_afternoon || check_in >= check_out || check_out <= check_in_morning
      
      now = Time.now
      late_times = 0
      check_in = case check_in
      when now.beginning_of_day..check_in_morning
        check_in_morning
      when check_in_morning..check_out_morning
        late_times = diff_in_minutes(check_in_morning, check_in)
        check_in
      when check_in_afternoon..check_out_afternoon
        late_times = diff_in_minutes(check_in_afternoon, check_in)
        check_in
      when check_out_morning..check_in_afternoon
        check_in_afternoon
      else
        check_out
      end

      soon_times = 0
      check_out = case check_out
      when check_in_morning..check_out_morning
        soon_times = diff_in_minutes(check_out, check_out_morning)
        check_out
      when check_in_afternoon..check_out_afternoon
        soon_times = diff_in_minutes(check_out, check_out_afternoon)
        check_out
      when check_out_morning..check_in_afternoon
        check_out_morning
      when check_out_afternoon..now.end_of_day
        check_out_afternoon
      else
        check_out
      end

      rest_time = (check_in <= check_out_morning && check_out >= check_in_afternoon) ? diff_in_minutes(check_out_morning, check_in_afternoon) : 0
      present_time = diff_in_minutes(check_in, check_out) - rest_time
      [present_time, late_times + soon_times]
    end

    def diff_in_minutes(from_time, to_time)
      ((to_time - from_time) / 60).to_i
    end

    def strftime_format(all_minutes)
      hours = all_minutes / 60 || 0
      minutes = all_minutes - hours * 60 || 0
      "#{hours < 10 ? ('0' + hours.to_s) : hours}:#{minutes < 10 ? ('0' + minutes.to_s) : minutes}"
    end
    
    def timefstr(str)
      time = str.split(':')
      Time.zone.now.change(hour: time[0], minute: time[1], seconds: time[2] || 0)
    end
  end

  ransacker :change_by, formatter: proc { |key| change_bys[key] }

  private

  def only_check_same_day
    return if start_at.nil? || end_at.nil? || start_at.all_day.cover?(end_at)

    errors.add(:base, I18n.t("activerecord.errors.models.time_sheet.attributes.date.only_one_day"))
  end

  def duplicate_time_sheet
    return unless TimeSheet.ransack({id_not_eq: id, start_at_gteq: start_at.beginning_of_day, end_at_lteq: end_at.end_of_day, user_id_eq: user_id}).result.present?

    errors.add(:base, I18n.t("activerecord.errors.models.time_sheet.attributes.date.only_one_day"))
  end
end
