# frozen_string_literal: true

class SettingsController < ApplicationController
  def index; end

  def reset_password
    if current_user.valid_password?(password_params['current_password']) && current_user.update(password_params.tap do |p|
                                                                                                  p.delete('current_password')
                                                                                                end)
      sign_in(current_user, :bypass => true)
      return_hash = { notice: I18n.t("users.reset_password.updated")}
    else
      return_hash = { alert: I18n.t("users.reset_password.failed") }
    end
    redirect_to settings_path, return_hash
  end

  def reset_preferred_locale
    if current_user.update(locale_params)
      return_hash = { notice: I18n.t("users.reset_preferred_locale.updated")}
    else
      return_hash = { alert: current_user.errors.full_messages.first}
    end
    redirect_to settings_path, return_hash
  end

  private

  def locale_params
    params.require(:user).permit(:preferred_locale)
  end

  def password_params
    params.require(:user).permit(:current_password, :password, :password_confirmation)
  end
end
