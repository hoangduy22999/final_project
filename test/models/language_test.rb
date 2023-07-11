# == Schema Information
#
# Table name: languages
#
#  id          :bigint           not null, primary key
#  code        :string           not null
#  name        :string           not null
#  native_name :string           not null
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#
require "test_helper"

class LanguageTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end
