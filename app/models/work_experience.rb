# == Schema Information
#
# Table name: work_experiences
#
#  id              :bigint           not null, primary key
#  company_name    :string
#  end_date        :date
#  from_date       :date
#  job_description :string
#  job_title       :string
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  user_id         :bigint
#
# Foreign Keys
#
#  user  (user_id => users.id)
#
class WorkExperience < ApplicationRecord
  # relationship
  belongs_to :user
end
