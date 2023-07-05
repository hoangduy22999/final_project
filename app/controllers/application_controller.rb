# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  def permission_denied_request
    redirect_to root_path, alert: 'Unauthorized request'
  end

  private

  def current_time
    Time.zone.now
  end

  def beginning_month
    current_time.beginning_of_month
  end
end
