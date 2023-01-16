# frozen_string_literal: true

module UserHelper
  def current_department(user)
    user.user_departments.order(start_date: :desc).first&.department&.name
  end

  def department_option
    Department.pluck(:name).each_with_object([['Deparment', '']]) do |department, object|
      object << [department.titleize, department]
    end
  end

  def status_option
    User.statuses.keys.each_with_object([['Status', '']]) do |status, object|
      object << [status.titleize, status]
    end
  end

  def role_option
    UserDepartment.roles.keys.each_with_object([['Role', '']]) do |role, object|
      object << [role.titleize, role]
    end
  end

  def city_option
    City.all.each_with_object([['All City', '']]) do |city, object|
      object << [city.name.upcase, city.id]
    end
  end
end
