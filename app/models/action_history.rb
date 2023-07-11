# == Schema Information
#
# Table name: action_histories
#
#  id            :bigint           not null, primary key
#  action_type   :integer
#  changed_value :json
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :string
#  user_id       :bigint
#
class ActionHistory < ApplicationRecord
  # relationships
  belongs_to :resource, polymorphic: true
  belongs_to :user

  # enums
  enum action_type: {
    create: 0,
    update: 1
  }, _prefix: true

  # ransacker for enums
  ransacker :action_type, formatter: proc { |key| action_types[key] }
end
