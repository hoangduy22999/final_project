class Admin::DepartmentsController < Admin::BaseController
  before_action :set_department, only: %i[show edit update destroy]
  def index
    @departments = Department.includes(:users, :manager, user_departments: :user)
                          .ransack(params[:where]).result
                          .order(created_at: :asc)
                          .paginate(page: params[:page] || 1)
                          .per_page(params[:per_page] || 10)
    @user_departments = UserDepartment.includes(:user).where(department: @departments).map do |user_department|
      {
        department_id: user_department.department_id,
        full_name: user_department.user.full_name + ' - ' + user_department.user.user_code,
        role: user_department.role
      }
    end                      
  end

  def new
    @department = Department.new
  end

  def show
    @users = @department.users.uniq
    @user_departments = @department.user_departments.map {|ud| { id: ud.id, user_id: ud.user_id, role: ud.role, department_id: ud.department_id } }
  end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to admin_departments_path, notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('departments.dashboard_name').downcase) }
        format.json { render :show, status: :ok, location: @department }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def create
    @department = Department.new(department_params)
    respond_to do |format|
      if @department.save
        format.html { redirect_to admin_departments_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('departments.dashboard_name').downcase) }
        format.json { render :show, status: :created, location: @department }
      else
        flash.now[:error] = @department.errors.full_messages.first
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @department.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @department.destroy

    respond_to do |format|
      format.html { redirect_to admin_departments_path, notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('departments.dashboard_name').downcase) }
      format.json { head :no_content }
    end
  end

  private

  def set_department
    @department = Department.find_by(id: params[:id])
  end

  def department_params
    params.require(:department).permit(:name)
  end
end