class NotificationsController < ApplicationController
  def index
    @notifications = current_user.recipient_notifications
                                 .includes(:sender)
                                 .order(created_at: :desc)
                                 .paginate(page: params[:page] || 1)
                                 .per_page(params[:per_page] || 15)
  end
  
  def show
    @notification = Notication.find(params[:id])
  end
end