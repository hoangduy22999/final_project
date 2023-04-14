class Admin::DepartmentsController < Admin::BaseController
  before_action :set_department, only: %i[show edit update destroy]
  def index
    @departments = Department.includes(:users, :manager, user_departments: :user).all.paginate(page: params[:page])
  end

  def new
    @department = Department.new
  end

  def show; end

  def update
    respond_to do |format|
      if @department.update(department_params)
        format.html { redirect_to departments_path, notice: 'Time Sheet was successfully updated.' }
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
        format.html { redirect_to departments_path, notice: 'Department was successfully created.' }
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
      format.html { redirect_to departments_path, notice: 'Department was successfully destroyed.' }
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