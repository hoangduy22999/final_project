#  capacity    :integer
#  description :string
#  end_at      :time
#  name        :string
#  rest_day    :integer          default([]), is an Array
#  start_at    :time
#  status      :integer 
colors = ['red', 'blue', 'green']
(3 - Room.all.count).times do |time|
  Room.create({
    name: 'Room_' + time.to_s,
    capacity: rand(10..20),
    description: 'Room_' + time.to_s,
    rest_day: [],
    start_at: '08:00',
    end_at: '21:00',
    color: colors[time % 3]
  })
end