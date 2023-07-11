# frozen_string_literal: true

class Admin::TimeSheetsController < Admin::BaseController
  before_action :set_time_sheet, only: %i[destroy edit update show]

  def index
    where = params[:where] || {}
    param_date = where.present? ? where["year_month"]&.split("-") : ""
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    @users = User.ransack(where).result
                 .order(id: :asc)
                 .paginate(page: params[:page] || 1)
                 .per_page(params[:per_page] || 15)
    time_sheets = TimeSheetService.new({user_ids: @users.pluck(:id), year_month: time}).perform
    department_info = DepartmentService.new({user_ids: @users.pluck(:id)}).perform
    @map_time_sheets = @users.map do |user|
      {
        user_id: user.id,
        user_code: user.user_code,
        user_name: user.full_name,
        month: time.strftime("%m/%Y")
      }.merge(time_sheets.find{|time_sheet| time_sheet[:user_id].eql?(user.id)} || {present_times: 0, late_times: 0,  forgot_keepings: 0})
       .merge(department_info.find{|department| department[:user_id].eql?(user.id)} || {})
    end
    
    @time_sheet = TimeSheet.new
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

  def user
    @time_sheets = TimeSheet.where(user_id: params[:id])
                            .ransack(params[:where]).result
    @user = User.find_by(id: params[:id])
  end

  def users
    @time_sheets = TimeSheet.ransack(params[:where]).result
    @user = @time_sheets&.first&.user
  end

  private
  def set_time_sheet
    @time_sheet = TimeSheet.find_by(id: params[:id])
  end

  def time_sheet_params
    attributes = params.require(:time_sheet).permit(:user_id, :start_at, :end_at)
  end
end
