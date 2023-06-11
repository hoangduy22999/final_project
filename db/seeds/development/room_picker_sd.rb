
room_ids = Room.all.pluck(:id)
user_ids = User.all.pluck(:id)

Room.all.each do |room|
  rand(5..10).times do |time|
    date = Time.zone.now.change(hour: rand(7..17)) - time.days
    RoomPicker.create!({
      user_id: user_ids.sample,
      room_id: room.id,
      start_at: date,
      end_at: date + 1.hours,
      repeat: true,
      repeat_type: rand(0..4),
      description: Faker::Lorem.sentence(word_count: 3)
    })
  end
end

