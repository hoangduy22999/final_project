# frozen_string_literal: true

class TimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:update]

  def index
    param_date = params[:year_month] || ""
    param_date = param_date.split("-")
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    @time_sheet = current_user.time_sheets.find_or_initialize_by(start_at: current_time.all_day)
  end

  def create
    @time_sheet = current_user.time_sheets.new({start_at: current_time})
    if @time_sheet.save
      redirect_to time_sheets_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('time_sheets.dashboard_name').downcase)
    else
      redirect_to time_sheets_path, alert: @time_sheet.errors.full_messages.first
    end
  end

  def update
    if @time_sheet.update({end_at: current_time})
      redirect_to time_sheets_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('time_sheets.dashboard_name').downcase)
    else
      redirect_to time_sheets_path, alert: @time_sheet.errors.full_messages.first
    end
  end

  private

  def time_sheet_params
    params.require(:time_sheet).permit(:field_name)
  end

  def set_time_sheet
    @time_sheet = TimeSheet.find(params[:id])

    redirect_to root_path, alert: I18n.t('toatr.messages.errors.unauthorized') unless @time_sheet.user_id.eql?(current_user.id)
  end
end
