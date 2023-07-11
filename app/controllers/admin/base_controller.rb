class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private
  
  def authenticate_admin!
    return if current_user.role_admin?

    permission_denied_response
  end
end