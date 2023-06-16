class Api::V1::ChatsController < Api::V1::ApplicationApi
  def index
    @messages = Message.includes(:sender).user_nessages(current_user.id).order("max(messages.created_at) DESC")
  end

  def create
    @message = Message.new(message_params)
    @message.sender_id = current_user.id
    @message.save!
  end

  private

  def message_params
    params.require(:message).permit(:receiver_id, :content)
  end
end