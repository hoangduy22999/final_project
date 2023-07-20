# frozen_string_literal: true

class ApplicationController < ActionController::Base
  # callbacks
  before_action :authenticate_user!
  skip_before_action :verify_authenticity_token
  before_action :set_locale
  before_action :set_cookies_user

  def permission_denied_response
    redirect_to root_path, alert: I18n.t('active_controller.errors.role.admin.permission_denied')
  end

  protected

  def set_locale
    # Remove inappropriate/unnecessary ones
    I18n.locale = params[:locale] ||    # Request parameter
      session[:locale] ||               # Current session
      (current_user.preferred_locale if user_signed_in?) ||  # Model saved configuration
      I18n.default_locale               # Set in your config files, english by super-default
  end

  private

  def current_time
    Time.zone.now
  end

  def beginning_month
    current_time.beginning_of_month
  end

  def set_cookies_user
    cookies[:token] = current_user&.generate_token
  end
end
