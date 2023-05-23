module Concerns::ActionHistory
  extend ActiveSupport::Concern

  included do
    after_commit :create_history, on: :create
    after_commit :update_history, on: :update

    def create_history
      ActionHistory.create!({
        action_type: "create",
        resource_id: self.id,
        resource_type: self.class.name,
        user_id: self.user_id
      })
    end

    def update_history
      
      ActionHistory.create!({
        action_type: "change",
        resource_id: self.id,
        resource_type: self.class.name,
        user_id: self.user_id,
        pre_value: ,
        column_name: ,
        after_value:
      })
    end
  end
end



#  id            :bigint           not null, primary key
#  action_type   :integer
#  after_value   :string
#  column_name   :string
#  pre_value     :string
#  resource_type :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#  resource_id   :string
#  user_id       :bigint