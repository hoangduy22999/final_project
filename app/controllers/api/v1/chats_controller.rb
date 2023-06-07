class Api::V1::ChatsController < Api::V1::ApplicationApi
  def index
    @messages = Message.includes(:sender).user_nessages(current_user.id).order("max(messages.created_at) DESC")
  end
end