# frozen_string_literal: true

class AdminTimeSheetsController < ApplicationController
  before_action :set_time_sheet, only: [:destroy, :edit, :update, :show]

  def index
    param_date = params[:date]
    time = param_date.blank? ? current_time : DateTime.new(param_date[:year].to_i, param_date[:month].to_i)
    @time_sheets = TimeSheet.includes(:user).where(keeping_time: time.all_day).paginate(page: params[:page]).per_page(10)
  end

  def create
  end

  def destroy
    @time_sheet.destroy

    respond_to do |format|
      format.html { redirect_to time_sheets_admin_path(year: params[:year], month: params[:month]), notice: "Time Sheet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @time_sheet.update(time_sheet_params)
        format.html { redirect_to time_sheet_url(@time_sheet), notice: "Time Sheet was successfully updated." }
        format.json { render :show, status: :ok, location: @time_sheet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @time_sheet.errors, status: :unprocessable_entity }
      end
    end
  end

  def show
  end

  def new
    @time_sheet = TimeSheet.new
  end

  private

  def time_sheet_params
    params.require(:time_sheet).permit(:keeping_type)
  end

  def set_time_sheet
    @time_sheet = TimeSheet.find_by(id: params[:id])
  end
end
