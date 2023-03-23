# frozen_string_literal: true

module TimeSheetHelper
  def current_select_date
    param_date = params[:date]
    param_date.blank? ? Time.zone.now : DateTime.new(param_date[:year].to_i, param_date[:month].to_i)
  end

  def check_type_options
    TimeSheet.keeping_types.keys.each_with_object([['-- Choose Type --', '']]) do |type, object|
      object << [type.titleize, type]
    end
  end

  def selected_user(user_id)
    user = User.find_by(id: user_id)
    user.present? ? "#{full_name(user)} - #{user.department&.name}" : nil
  end

  def time_late_strftime(minutes)
    hour = minutes / 60
    minutes = minutes % 60
    hour = hour < 10 ? "0#{hour}" : hour.to_s
    minutes = minutes < 10 ? "0#{minutes}" : minutes.to_s
    "#{hour}:#{minutes}"
  end
end
