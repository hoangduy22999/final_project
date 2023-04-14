class Admin::BaseController < ApplicationController
  before_action :authenticate_admin!

  private
  
  def authenticate_admin!
    return if current_user.role_admin?

    redirect_to root_path, alert: 'You are not allowed to this action'
  end
end