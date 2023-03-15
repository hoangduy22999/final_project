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
end
