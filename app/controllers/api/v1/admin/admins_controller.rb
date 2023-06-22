class Api::V1::Admin::AdminsController < Api::V1::ApplicationApi
  before_action :authenticate_admin!

  private
  
  def authenticate_admin!
    raise Unauthorized, I18n.t("common.text.unauthorized") unless current_user&.role_admin?
  end
end