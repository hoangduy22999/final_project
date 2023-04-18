# == Schema Information
#
# Table name: dependents
#
#  id           :bigint           not null, primary key
#  address      :string
#  birthday     :date
#  name         :string
#  phone        :string
#  relationship :integer
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  user_id      :bigint
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class Dependent < ApplicationRecord
  # relationship
  belongs_to :user
end
