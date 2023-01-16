# frozen_string_literal: true

module UserHelper
  def current_department(user)
    user.user_departments.order(start_date: :desc).first&.department&.name
  end

  def department_options
    Department.pluck(:name).each_with_object([['-- Choose Deparment --', '']]) do |department, object|
      object << [department.titleize, department]
    end
  end

  def status_options
    User.statuses.keys.each_with_object([['-- Choose Status --', '']]) do |status, object|
      object << [status.titleize, status]
    end
  end

  def role_options
    UserDepartment.roles.keys.each_with_object([['-- Chose Role --', '']]) do |role, object|
      object << [role.titleize, role]
    end
  end

  def gender_options
    User.genders.keys.each_with_object([['-- Choose Gender --', '']]) do |gender, object|
      object << [gender.upcase, gender]
    end
  end

  def city_options
    City.all.each_with_object([['All City', '']]) do |city, object|
      object << [city.name.upcase, city.id]
    end
  end
end
