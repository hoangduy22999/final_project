class Api::V1::Admin::UserDepartmentsController < Api::V1::Admin::AdminsController
  def not_have_department
    data = User.where.not(id: UserDepartment.all.pluck(:user_id)).map do |user|
      {
        user_id: user.id,
        user_name: user.full_name,
        user_age: user.age
      }
    end

    render_index(data, Admin::UserDepartments::IndexSerializer)
  end
end