class ChatChannel < ApplicationCable::Channel
  def subscribed
    stream_from "ChatChannel_#{User.find_by(id: User.login_id(params[:token])).email}"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
    stop_all_streams
  end
end