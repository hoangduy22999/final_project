# frozen_string_literal: true

class TimeSheetsController < ApplicationController
  def index
    param_date = params[:date]
    time = param_date.blank? ? current_time : DateTime.new(param_date[:year].to_i, param_date[:month].to_i)
    @result = []
    end_month = time.end_of_month
    beginning_month = time.beginning_of_month
    current_month = time.month
    time_sheets = TimeSheet.where(keeping_time: time.all_month,
                                  user_id: params[:user_id] || current_user.id).order(:keeping_time)
    time_sheets = time_sheets.map do |ts|
                    { day: ts.keeping_time.day, time: ts.keeping_time.strftime('%H:%M'), type: ts.keeping_type,
                      time_late: current_user.late_time(ts.keeping_time.all_day) }
                  end.group_by { |a| a[:day] }
    start_date = beginning_month.beginning_of_week
    end_date = end_month.end_of_week
    while start_date < end_date
      tmp_day = start_date.day
      @result << if start_date.month != current_month
                   { day: tmp_day, current_month: false }
                 elsif !time_sheets[tmp_day]
                   { day: tmp_day, current_month: true }
                 else
                   time_sheets[tmp_day]
                 end
      start_date += 1.days
    end
    @time_sheets = TimeSheet.new
  end

  def admin_index
    param_date = params[:date]
    time = param_date.blank? ? current_time : DateTime.new(param_date[:year].to_i, param_date[:month].to_i)
    @time_sheets = TimeSheet.includes(:user).where(keeping_time: time.all_day).paginate(page: params[:page]).per_page(10)
  end

  def create
    time_sheet = current_user.time_sheets.new(time_sheet_params.merge(keeping_time: Time.new.localtime))
    if time_sheet.save
      redirect_to time_sheets_path, notice: "#{time_sheet.keeping_type} has been successfully"
    else
      redirect_to time_sheets_path, alert: time_sheet.errors.full_messages.first
    end
  end

  private

  def time_sheet_params
    params.require(:time_sheet).permit(:keeping_type)
  end
end
