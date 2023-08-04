class Admin::UserDepartmentsController < Admin::BaseController
  before_action :set_user_department, only: [:update, :destroy]

  def index
  end

  def update
  end

  def update_multi
    case params[:update_type]
    when 'editRole'
      user_department = UserDepartment.find_by(user_id: params[:user_id], department_id: params[:department_id])
      if user_department.nil?
        return_hash = { alert: I18n.t('active_controller.errors.department.select_user')}
      elsif user_department.update(role: params[:role].blank? ? "member" : params[:role])
        return_hash = { notice: I18n.t('active_controller.messages.created', object_name: I18n.t('roles.dashboard_name').downcase)}
      else
        return_hash = { alert: user_department.errors.full_messages.first}
      end
    when 'moveDepartment'
      user_department = UserDepartment.find_by(department_id: params[:department_id], user_id: params[:move_user_id])
      if user_department.nil?
        return_hash = {alert: I18n.t('active_controller.errors.department.select_user')}
      elsif user_department.user.status_inactive?
        return_hash = {alert: I18n.t('active_controller.errors.user_inactive')}
      elsif user_department.update(department_id: params[:target_department].blank? ? params[:department_id] : params[:target_department])
        return_hash = {notice: I18n.t('active_controller.messages.created', object_name: I18n.t('departments.dashboard_name').downcase)}
      else
        return_hash = {alert: user_department.errors.full_messages.first}
      end
    when 'addMulti'
      users = params[:users].split(',')
      if users.blank?
        return_hash = { alert: I18n.t('active_controller.errors.department.select_user')}
      else
        users.each.with_index do |user, index|
          user_id, duration, start_date = user.split('|')
          duration = duration.to_i
          year, month, day = start_date.split('-').map(&:to_i)
          start_date = Date.new(year, month, day)
          ud = UserDepartment.find_or_initialize_by(user_id: user_id)
          if ud.user.status_inactive?
            return redirect_to admin_department_path(id: params[:department_id]), { alert: I18n.t('active_controller.errors.user_inactive')}
          elsif !ud.update({role: "member", department_id: params[:department_id], start_date: start_date}.merge(duration.to_i <= 24 ? {end_date: start_date + duration.months} : {}))
            return redirect_to admin_department_path(id: params[:department_id]), { alert: ud.errors.full_messages.first}
          end
        end
        return_hash = { notice: I18n.t('active_controller.messages.added_member')}
      end
    else
    end
    redirect_to admin_department_path(id: params[:department_id]), return_hash
  end

  def destroy
    department_id = @user_department.department.id
    if @user_department.destroy
      return_hash = { notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('user_departments.dashboard_name').downcase)}
    else
      return_hash = { alert: @user_department.errors.full_messages.first}
    end

    redirect_to admin_department_path(id: department_id), return_hash
  end

  private

  def set_user_department
    @user_department = UserDepartment.find(params[:id])
  end

  def user_department_params
    params.require(:user_department).permit(:user_id, :department_id, :role)
  end
end