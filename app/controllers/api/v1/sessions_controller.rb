class Api::V1::SessionsController < Api::V1::ApplicationApi
  skip_before_action :authorized, only: :create

  def create
    user = User.find_by email: params[:email]
    raise NotFound, I18n.t("common.text.not_found") unless user
    raise Unauthorized, I18n.t("common.text.wrong_password_or_email") unless user.valid_password? params[:password]

    # current_device.login_count += 1
    # current_device.failure_login_count = 0
    # last_login_time = user.devices.maximum(:final_login)
    # current_device.final_login = Time.zone.now
    # current_device.connect!(user)
    # long_time_no_login_text =
    #   if last_login_time && (last_login_time < eval(Settings.long_time_no_login.times).ago) # rubocop:disable Security/Eval
    #     Settings.long_time_no_login.text_display
    #   end

    render json:
      {
        token: user.generate_token,
        user: user
        # work_unread_count: user.work_unread_count,
        # long_time_no_login_text: long_time_no_login_text
      }, status: :ok
  end

  def logout
    token = request.headers["HTTP_DEVICE_ID_TOKEN"] || ''

    # if token.present?
    #   current_user.devices.where(device_token: request.headers["HTTP_DEVICE_ID_TOKEN"])&.delete_all
    # end

    render json: { token: '' }, status: :ok
  end
end