# == Schema Information
#
# Table name: educations
#
#  id             :bigint           not null, primary key
#  degree         :string
#  end_date       :date
#  name           :string
#  specialization :string
#  start_date     :date
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#  user_id        :bigint
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class Education < ApplicationRecord
  # relationship
  belongs_to :user
end
