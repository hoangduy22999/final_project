# frozen_string_literal: true

module TimeSheetHelper
  def current_select_date
    param_date = params[:date]
    param_date.blank? ? Time.zone.now : DateTime.new(param_date[:year].to_i, param_date[:month].to_i)
  end
end
