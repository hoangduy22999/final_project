# frozen_string_literal: true

debug_print __FILE__

print_log('INSERT TIMESHEET')

now = Time.zone.now
skip_users = TimeSheet.where(start_at: ((now - 60.days)..now)).pluck(:user_id).uniq

attributes = User.where.not(id: skip_users).pluck(:id).map do |user_id|
  (0..60).map do |time|
    tmp_day = now - time.days
    checkin_time = tmp_day.change(hour: rand(7..9), minutes: rand(0..59))
    checkout_time = tmp_day.change(hour: rand(16..18), minutes: rand(0..59))

    TimeSheet.create!({
      start_at: checkin_time,
      end_at: checkout_time,
      user_id: user_id
    })
  end
end