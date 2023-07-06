module UserDepartmentHelper
  def department_options
    Department.all.each_with_object([['-- Choose Department --', '']]) do |department, object|
      object << [department.name.titleize, department.id]
    end
  end

  def department_options_without(target_department)
    Department.where.not(id: target_department.id).each_with_object([['-- Choose Department --', '']]) do |department, object|
      object << [department.name.titleize, department.id]
    end
  end

  def user_options(department)
    department.users.each_with_object([['-- Choose User --', '']]) do |user, object|
      object << [user.full_name, user.id]
    end
  end
end