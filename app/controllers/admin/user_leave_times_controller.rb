class Admin::UserLeaveTimesController < Admin::BaseController
  before_action :set_user, :set_user_leave_time

  def update
    return_hash = {notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('user_leave_times.dashboard_name').downcase)}
    redirect_to admin_user_path(id: @user.id, tab_pane: "ex-with-icons-tab-3"), return_hash
  end

  private

  def set_user
    @user = User.find_by(id: params[:user_id])
  end

  def set_user_leave_time
    @user_leave_time = UserLeaveTime.find(params[:id])
  end

  def user_leave_time_params
    params.require(:user_leave_time).permit(:user_id, :paid_leave_max, :paid_leave_taken, :unpaid_leave_max, :unpaid_leave_taken)
  end
end