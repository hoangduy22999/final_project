class V2::DepartmentService
  attr_reader :user_ids

  def initialize(params = {})
    @user_ids = params[:user_ids]
  end

  def perform
    calculte
  end

  private

  def calculte
    department = Department.all.pluck(:id, :name).to_h
    user_departments = UserDepartment.all
    user_departments.map do |user_department|
      { 
        role: user_department.role, 
        user_id: user_department.user_id, 
        department: department[user_department.department_id]
      }
    end
  end
end