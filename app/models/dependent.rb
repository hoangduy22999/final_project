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

  # enum
  enum relationship: { father: 0, mother: 1, brother: 2, sister: 3, wife: 4, husband: 5, son: 6, daughter: 7, other: 8}
end
