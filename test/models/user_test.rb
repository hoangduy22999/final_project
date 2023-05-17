# frozen_string_literal: true

# == Schema Information
#
# Table name: users
#
#  id                          :bigint           not null, primary key
#  address                     :string           not null
#  avatar                      :string
#  birthday                    :datetime         not null
#  current_sign_in_at          :datetime
#  current_sign_in_ip          :string(255)
#  email                       :string           default(""), not null
#  encrypted_password          :string           default(""), not null
#  first_name                  :string
#  gender                      :integer          default("male"), not null
#  last_name                   :string
#  last_sign_in_at             :datetime
#  last_sign_in_ip             :string(255)
#  phone                       :string           not null
#  remember_created_at         :datetime
#  reset_passwomessagerd_token :string
#  reset_password_sent_at      :datetime
#  reset_password_token        :string(255)
#  role                        :integer          default("user"), not null
#  salary                      :integer
#  sign_in_count               :integer          default(0)
#  status                      :integer          default("active"), not null
#  created_at                  :datetime         not null
#  updated_at                  :datetime         not null
#  city_id                     :bigint
#  district_id                 :bigint
#
# Indexes
#
#  index_users_on_district_id           (district_id)
#  index_users_on_email                 (email)
#  index_users_on_reset_password_token  (reset_password_token) UNIQUE
#  index_users_on_role                  (role)
#  index_users_on_status                (status)
#
# Foreign Keys
#
#  district  (district_id => districts.id)
#
require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
