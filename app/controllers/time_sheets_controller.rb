# frozen_string_literal: true

class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:update]

  def index
    param_date = params[:year_month] || ""
    param_date = param_date.split("-")
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    @time_sheet = TimeSheet.new
  end

  def create
    @time_sheet = current_user.time_sheets.new(time_sheet_params.merge(keeping_time: Time.now))
    if @time_sheet.save
      redirect_to time_sheets_path, notice: "#{@time_sheet.keeping_type} has been create successfully"
    else
      redirect_to time_sheets_path, alert: @time_sheet.errors.full_messages.first
    end
  end

  private

  def time_sheet_params
    params.require(:time_sheet).permit(:keeping_type)
  end
end
