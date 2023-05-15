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
    City.all.order(name: :asc).each_with_object([['-- Choose City --', '']]) do |city, object|
      object << [city.name, city.id]
    end
  end

  def default_district_options(user)
    district_options = [["-- Choose District --", ""]]
    user.new_record? ? district_options :  district_options << [user.district&.name, user.district&.id]
  end

  def salary_decoration(salary)
    return salary_decoration(salary / 1000) if salary > 1000

    salary
  end

  def role_department(user)
    user_department = user.user_department
    user_department.department.name + ' ' + user_department.role
  end

  def multi_day_present(start_date, end_date)
    if start_date.year == end_date.year
    else
      
    end
  end

  def leader_options
    leader_ids = UserDepartment.role_admin.pluck(:user_id)
    User.where(user_id: leader_ids).or(User.role_admin)
  end

  def user_relationship_options
    Dependent.relationships.keys.each_with_object([['-- Choose Relation --', '']]) do |relation, object|
      object << [relation.titleize, relation]
    end
  end
end
