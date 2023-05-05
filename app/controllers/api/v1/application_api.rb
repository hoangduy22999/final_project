class Api::V1::ApplicationApi < ActionController::API
  # before_action :create_device_if_not_exists
  before_action :authorized
  skip_before_action :authorized, only: %i[logged_id current_user]

  class Unauthorized < StandardError; end
  class NotFound < StandardError; end
  class BadRequest < StandardError; end

  rescue_from Unauthorized do |errors|
    render json: { errors: errors || I18n.t("common.text.unauthorized") }, status: :unauthorized
  end

  rescue_from NotFound, ActiveRecord::RecordNotFound do |errors|
    render json: { errors: I18n.t("common.text.not_found") }, status: :not_found
  end

  rescue_from ActionController::ParameterMissing do |errors|
    render json: { errors: errors }, status: :bad_request
  end

  rescue_from ArgumentError, ActiveRecord::RecordInvalid do |errors|
    render json: { errors: errors }, status: :bad_request
  end

  rescue_from BadRequest do |errors|
    render json: { errors: errors }, status: :bad_request
  end

  # def current_device
  #   @current_device ||= Device.find_by(device_token: current_device_id)
  # end

  def create_device_if_not_exists
    raise Unauthorized, I18n.t("common.text.unauthorized") unless current_device_id.present?
    raise Unauthorized, I18n.t("common.text.unauthorized") unless current_client.present?

    device = Device.find_or_initialize_by(device_token: current_device_id)

    if device.new_record?
      device.assign_attributes(
        login_count: 0,
        failure_login_count: 0,
        final_login: nil,
        client_id: current_client.id
      )
    end

    device.device_name = request.headers["Client-Device-Name"]
    device.os_info = request.headers["Client-Os-Info"]
    device.app_version = request.headers["Client-App-Version"]
    device.final_access = Time.zone.now
    device.save!
  end

  def current_client
    @current_client ||= Client.find_by(client_type: request.headers["Client-Type"])
  end

  def current_device_id
    @current_device_id_token ||= request.headers["Device-Id-Token"]
  end

  private

  def logged_id
    header_token = request.headers['token']
    decode_token = JWT.decode(header_token, ENV['HMAC_SECRET'], true, { algorithm: 'HS256' }).first
    return nil unless decode_token['expiry'] && decode_token['expiry'].to_datetime >= DateTime.now

    decode_token['user_id']
  rescue JWT::DecodeError
    nil
  end

  def authorized
    @current_user = User.find_by id: logged_id
    raise Unauthorized, I18n.t("common.text.unauthorized") unless @current_user
    # && current_device.user_id == @current_user&.id
  end
end