# frozen_string_literal: true

class ApplicationController < ActionController::Base
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token

  private

  def current_time
    Time.zone.now
  end

  def beginning_month
    current_time.beginning_of_month
  end
end
