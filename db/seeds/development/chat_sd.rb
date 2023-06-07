skip_user_ids = Message.pluck(:sender_id)
receiver_ids = User.pluck(:id)


User.where.not(id: skip_user_ids).pluck(:id).map do |user_id|
  Message.create({
    sender_id: user_id,
    receiver_id: (receiver_ids - [user_id]).sample,
    content: Faker::Lorem.paragraph
  })
end