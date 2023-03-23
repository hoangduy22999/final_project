# frozen_string_literal: true

class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:update]

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
                      time_late: ts.time_late }
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

  def create
    if params['time_sheet']['admin_action'].eql?('true')
      @time_sheet = TimeSheet.new(time_sheet_admin_params)
      if @time_sheet.save
        redirect_to admin_time_sheets_path, notice: "#{@time_sheet.keeping_type} has been create successfully"
      else
        redirect_to new_admin_time_sheet_path, alert: @time_sheet.errors.full_messages.first
      end
    else
      @time_sheet = current_user.time_sheets.new(time_sheet_params.merge(keeping_time: Time.now))
      if @time_sheet.save
        redirect_to time_sheets_path, notice: "#{@time_sheet.keeping_type} has been create successfully"
      else
        redirect_to time_sheets_path, alert: @time_sheet.errors.full_messages.first
      end
    end
  end

  def update
    if @time_sheet.update(time_sheet_admin_params)
      redirect_to admin_time_sheet_path(@time_sheet), notice: "#{@time_sheet.keeping_type} has been update successfully"
    else
      redirect_to admin_time_sheet_path(@time_sheet.reload), alert: @time_sheet.errors.full_messages.first
    end
  end

  private

  def time_sheet_params
    params.require(:time_sheet).permit(:keeping_type)
  end

  def time_sheet_admin_params
    attributes = params.require(:time_sheet).permit(:keeping_date, :keeping_time, :user, :keeping_type)
    time = ''
    unless attributes[:keeping_date].blank? || attributes[:keeping_time].blank?
      time = Time.parse(attributes[:keeping_date]).in_time_zone + Time.parse(attributes[:keeping_time]).seconds_since_midnight.seconds
    end
    user_name = attributes[:user].split('-').first&.strip
    user_id = User.ransack(full_name_eq: user_name).result.first&.id
    { keeping_type: attributes[:keeping_type], user_id: user_id, keeping_time: time }
  end

  def set_time_sheet
    @time_sheet = TimeSheet.find_by(id: params[:id])
  end
end
