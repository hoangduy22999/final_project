# frozen_string_literal: true

class Admin::TimeSheetsController < Admin::BaseController
  before_action :set_time_sheet, only: %i[destroy edit update show]

  def index
    where = params[:where] || {}
    param_date = where.present? ? where["year_month"]&.split("-") : ""
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    @time_sheets = TimeSheet.includes(:user, :department).where(keeping_time: time.all_month, user: {status: 'active'})
                            .ransack(where).result
                            .order(keeping_time: :desc)
                            .paginate(page: params[:page]).per_page(15)
  end

  def create
    @time_sheet = TimeSheet.change_by_admin.new(time_sheet_params)
    if @time_sheet.save
      redirect_to admin_time_sheets_path, notice: "Time Sheet has been create successfully"
    else
      redirect_to admin_time_sheets_path, alert: @time_sheet.errors.full_messages.first
    end
  end

  def destroy
    @time_sheet.destroy

    respond_to do |format|
      format.html do
        redirect_to admin_time_sheets_path(year: params[:year], month: params[:month]),
                    notice: 'Time Sheet was successfully destroyed.'
      end
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @time_sheet.update(time_sheet_params.merge(change_by: 'admin'))
        format.html { redirect_to admin_time_sheets_path(year: params[:year], month: params[:month]), notice: 'Time Sheet was successfully updated.' }
      else
        format.html { edirect_to admin_time_sheets_path(year: params[:year], month: params[:month]), alert: @time_sheet.errors.full_messages.first  }
      end
    end
  end

  def show; end

  def new
    @time_sheet = TimeSheet.new
  end

  private
  def set_time_sheet
    @time_sheet = TimeSheet.find_by(id: params[:id])
  end

  def time_sheet_params
    attributes = params.require(:time_sheet).permit(:keeping_date, :keeping_time, :user, :keeping_type)
    time = ''
    unless attributes[:keeping_date].blank? || attributes[:keeping_time].blank?
      time = Time.parse(attributes[:keeping_date]).in_time_zone + Time.parse(attributes[:keeping_time]).seconds_since_midnight.seconds
    end
    user_name = attributes[:user].split('-').first&.strip
    user_id = User.ransack(full_name_eq: user_name).result.first&.id
    { keeping_type: attributes[:keeping_type], user_id: user_id, keeping_time: time }
  end
end
