# frozen_string_literal: true

class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:update]

  def index
    param_date = params[:year_month] || ""
    param_date = param_date.split("-")
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    result = []
    end_month = time.end_of_month
    beginning_month = time.beginning_of_month
    current_month = time.month
    time_sheets = TimeSheet.where(keeping_time: time.all_month,
                                  user_id: params[:user_id] || current_user.id).order(:keeping_time)
    time_sheets = time_sheets.map do |ts|
                    { day: ts.keeping_time.day, time: ts.keeping_time.strftime('%H:%M'), type: ts.keeping_type,
                      time_late: ts.time_late }
                  end.group_by { |a| a[:day] }
    start_date = beginning_month.beginning_of_week
    end_date = end_month.end_of_week
    while start_date < end_date
      tmp_day = start_date.day
      result << if start_date.month != current_month
                   { day: tmp_day, current_month: false }
                 elsif !time_sheets[tmp_day]
                   { day: tmp_day, current_month: true }
                 else
                   time_sheets[tmp_day]
                 end
      start_date += 1.days
    end
    time_sheet = TimeSheet.new(keeping_type: current_keeping_type)
    @data = {result: result, time_sheet: time_sheet, disabled: check_out_today}
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

  def set_time_sheet
    @time_sheet = TimeSheet.find_by(id: params[:id])
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
