class Leader::BaseController < ApplicationController
  before_action :authenticate_leader!

  private
  
  def authenticate_leader!
    return if current_user.leader_department?

    redirect_to root_path, alert: 'You are not allowed to this action'
  end
end