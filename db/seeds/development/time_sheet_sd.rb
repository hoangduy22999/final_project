# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT TIMESHEET')

now = Time.zone.now
skip_users = TimeSheet.where(keeping_time: ((now - 60.days)..now)).pluck(:user_id)

attributes = User.where.not(id: skip_users).pluck(:id).each do |user_id|
  60.times do |time|
    tmp_day = now - time.days
    checkin_time = tmp_day.change(hour: 8)
    checkout_time = tmp_day.change(hour: 18)
    2.times do |i|
      TimeSheet.create({
                         user_id: user_id,
                         keeping_type: i,
                         keeping_time: (i.zero? ? checkin_time : checkout_time) + rand(-30..30).minutes
                       })
    end
  end
end
