# frozen_string_literal: true

class Admin::TimeSheetsController < Admin::BaseController
  before_action :set_time_sheet, only: %i[destroy edit update show]
  before_action :set_user

  def summary
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

  def index
    check_in_morning, check_out_morning, check_in_afternoon, check_out_afternoon = CompanySetting.current_time_settings
    @options = {
                check_in_morning: check_in_morning,
                check_out_morning: check_out_morning,
                check_in_afternoon: check_in_afternoon,
                check_out_afternoon: check_out_afternoon
              }
    where = params[:where] || {}
    param_date = where.present? ? where["year_month"]&.split("-") : ""
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    @time_sheets = @user.time_sheets.ransack(where.merge(start_at_gteq: time.beginning_of_month, end_at_lteq: time.end_of_month))
                                   .result
  end

  def create
    @time_sheet = TimeSheet.change_by_admin.new(time_sheet_params)
    if @time_sheet.save
      redirect_to admin_time_sheets_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('time_sheets.dashboard_name').downcase)
    else
      redirect_to admin_time_sheets_path, alert: @time_sheet.errors.full_messages.first
    end
  end

  def destroy
    @time_sheet.destroy

    respond_to do |format|
      format.html do
        redirect_to admin_user_time_sheets_path(user_id: @user.id, where: {"year_month" => @time_sheet.start_at.strftime('%Y-%m') }),
                    notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('time_sheets.dashboard_name').downcase)
      end
      format.json { head :no_content }
    end
  end

  def update
    respond_to do |format|
      if @time_sheet.update(time_sheet_params(@time_sheet).merge(change_by: 'admin'))
        format.html { redirect_to admin_user_time_sheets_path(user_id: @user.id, where: {"year_month" => @time_sheet.start_at.strftime('%Y-%m') }), notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('time_sheets.dashboard_name').downcase) }
      else
        format.html { edirect_to admin_user_time_sheets_path(user_id: @user.id, where: {"year_month" => @time_sheet.start_at.strftime('%Y-%m') }), alert: @time_sheet.errors.full_messages.first  }
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
    @time_sheet = TimeSheet.find_by(id: params[:id], user_id: params[:user_id])
  end

  def time_sheet_params(time_sheet)
    attributes = params.require(:time_sheet).permit(:user_id, :start_at, :end_at)
    start_at = Time.parse(attributes[:start_at])
    end_at = Time.parse(attributes[:end_at])
    {
      start_at: time_sheet.start_at.change(hour: start_at.hour, min: start_at.min),
      end_at: time_sheet.end_at.change(hour: end_at.hour, min: end_at.min)
    }
  end

  def set_user
    @user = User.find_by(id: params[:user_id])
  end
end
