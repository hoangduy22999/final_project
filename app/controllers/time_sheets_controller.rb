# frozen_string_literal: true

class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:update]

  def index
    param_date = params[:year_month] || ""
    param_date = param_date.split("-")
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    @data = TimeSheetService.new(
                                user_id: params[:user_id] || current_user.id,
                                year_month: time,
                                current_keeping_type: current_keeping_type,
                                check_out_today: check_out_today
                                ).perfom
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

  def current_keeping_type
    check_in = TimeSheet.keeping_type_check_in.where(keeping_time: Time.now.all_day).count
    check_out = TimeSheet.keeping_type_check_out.where(keeping_time: Time.now.all_day).count
    check_in > check_out ?  "check_out" : "check_in"
  end

  def check_out_today
    TimeSheet.keeping_type_check_out.where(keeping_time: Time.now.all_day).present?
  end
end
