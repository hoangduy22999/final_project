module LeaveRequestHelper
  def leader_options
    UserDepartment.includes(:user, :department).role_leader.each_with_object([['-- Choose Leader --', '']]) do |leader, object|
      user = leader.user
      object << [user.full_name + " - " + leader.department.name, user.id]
    end
  end

  def leave_type_options
    LeaveRequest.leave_types.keys.each_with_object([['-- Choose Type --', '']]) do |leave_type, object|
      object << [leave_type.titleize, leave_type]
    end
  end

  def users_in_department(current_user)
    User.where(id: current_user.department.user_departments.pluck(:user_id))
  end


  def time_range_options
    [
      [ 'Today', 'today' ],
      [ 'Yesterday', 'yesterday' ],
      [ 'This Week', 'this_week' ],
      [ 'Last Week', 'last_week' ],
      ['This Month', 'this_month'],
      ['Last Month', 'last_month'],
      ['This Year', 'this_year'],
      ['Last Year', 'last_year'],
      ['All', 'all']
    ]
  end

  def convert_date_params(params)
    return {} unless params[:where]

    params[:where].merge(
    case params[:where][:time_range]
    when "all"
      {}
    when "today"
      {start_date_gteq: Time.now.beginning_of_day, end_date_lteq: Time.now.end_of_day}
    when "yesterday"
      {start_date_gteq: Time.now.yesterday.beginning_of_day, end_date_lteq: Time.now.yesterday.end_of_day}
    when "this_week"
      {start_date_gteq: Time.now.beginning_of_week, end_date_lteq: Time.now.end_of_week}
    when "last_week"
      {start_date_gteq: Time.now.last_week.beginning_of_week, end_date_lteq: Time.now.last_week.end_of_week}
    when "this_month"
      {start_date_gteq: Time.now.beginning_of_month, end_date_lteq: Time.now.end_of_month}
    when "last_month"
      {start_date_gteq: Time.now.last_month.beginning_of_month, end_date_lteq: Time.now.last_month.end_of_month}
    when "this_year"
      {start_date_gteq: Time.now.beginning_of_year, end_date_lteq: Time.now.end_of_year}
    when "last_year"
      {start_date_gteq: Time.now.last_year.beginning_of_year, end_date_lteq: Time.now.last_year.end_of_year}
    else
      {start_date_gteq: Time.now.beginning_of_day, end_date_lteq: Time.now.end_of_day}
    end
    )
  end

  def reason_options
    LeaveRequest.reasons.keys.each_with_object([['-- Choose Reason --', '']]) do |reason, object|
      object << [reason.titleize, reason]
    end
  end
end