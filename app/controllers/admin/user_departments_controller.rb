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
        return_hash = { alert: 'Please select a user'}
      elsif user_department.update(role: params[:role].blank? ? "member" : params[:role])
        return_hash = { notice: "Role updated successfully"}
      else
        return_hash = { alert: user_department.errors.full_messages.first}
      end
    when 'moveDepartment'
      user_department = UserDepartment.find_by(department_id: params[:department_id], user_id: params[:move_user_id])
      if user_department.nil?
        return_hash = { alert: 'Please select a user'}
      elsif user_department.update(department_id: params[:target_department].blank? ? params[:department_id] : params[:target_department])
        return_hash = { notice: "Department updated successfully"}
      else
        return_hash = { alert: user_department.errors.full_messages.first}
      end
    when 'addMulti'
      users = User.where(id: params[:user_ids])
      users = users.map { |user| {user_id: user.id, department_id: params[:department_id]}}
      if params[:user_ids].blank?
        return_hash = { alert: 'Please select a user'}
      elsif UserDepartment.create(users)
        return_hash = { notice: "User added successfully"}
      else
        return_hash = { alert: "Something went wrong"}
      end
    else
    end

    redirect_to admin_department_path(Department.find(params[:department_id])), return_hash
  end

  def destroy
    department = @user_department.department
    if @user_department.destroy
      return_hash = { notice: "User destroy successfully"}
    else
      return_hash = { alert: @user_department.errors.full_messages.first}
    end
    redirect_to admin_department_path(department), return_hash
  end

  private

  def set_user_department
    @user_department = UserDepartment.find(params[:id])
  end

  def user_department_params
    params.require(:user_department).permit(:user_id, :department_id, :role)
  end
end