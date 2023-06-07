class RoomChatChanel < ApplicationCable::Channel
  def subscribed
    Rails.logger.info "Subscribed to #{params[:user_id]}"

    stream_from "chat_#{params[:user_id]}"
  end

  def unsubscribed
    stop_all_streams
  end
end