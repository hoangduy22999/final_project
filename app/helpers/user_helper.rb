# frozen_string_literal: true

module UserHelper
  def current_department(user)
    user.user_departments.order(start_date: :desc).first&.department&.name
  end

  def department_options
    Department.all.each_with_object([['-- Choose Deparment --', '']]) do |department, object|
      object << [department&.name&.titleize, department.id]
    end
  end

  def status_options
    User.statuses.keys.each_with_object([['-- Choose Status --', '']]) do |status, object|
      object << [status.titleize, status]
    end
  end

  def role_options
    UserDepartment.roles.keys.each_with_object([['-- Choose Role --', '']]) do |role, object|
      object << [role.titleize, role]
    end
  end

  def user_role_options
    User.roles.keys.each_with_object([['-- Choose Status --', '']]) do |status, object|
      object << [status.titleize, status]
    end
  end

  def gender_options
    User.genders.keys.each_with_object([['-- Choose Gender --', '']]) do |gender, object|
      object << [gender.titleize, gender]
    end
  end

  def city_options
    City.all.each_with_object([['-- Choose City --', '']]) do |city, object|
      object << [city.name.titleize, city.id]
    end
  end
end
