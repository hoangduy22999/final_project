class ChatsController < ApplicationController
  def index
    @receiver_users = Message.select(:receiver_id).includes(:sender).user_messages(current_user.id).group(:receiver_id).order("max(messages.created_at) DESC")
    @messages = []
  end
end