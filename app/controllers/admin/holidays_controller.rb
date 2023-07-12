class Admin::HolidaysController < Admin::BaseController
  before_action :set_holiday, only: %i[update show destroy]

  def index
    where = params[:where] || {}
    param_date = where.present? ? where["year_month"]&.split("-") : ""
    time = param_date.blank? ? current_time : DateTime.new(param_date.first.to_i, param_date.last.to_i)
    where.merge!(start_date_lteq: strftime_custom(time.end_of_month), end_date_gteq: strftime_custom(time.beginning_of_month))
    @holidays = Holiday.ransack(where).result
                       .order(start_date: :desc)
                       .paginate(page: params[:page])
                       .per_page(params[:per_page] || PER_PAGE_BIG)
  end

  def new
    @holiday = Holiday.new
  end

  def show; end

  def create
    @holiday = Holiday.new(holiday_params)
    respond_to do |format|
      if cannot? :create, @holiday
        format.html { redirect_to admin_holidays_path(@holiday), alert: I18n.t('active_controller.errors.role.admin.permission_denied') }
      elsif @holiday.save
        format.html { redirect_to admin_holidays_path(@holiday), notice: I18n.t('active_controller.messages.created', object_name: I18n.t('holidays.dashboard_name').downcase) }
      else
        format.html { redirect_to admin_holidays_path(@holiday), alert: @holiday.errors.full_messages.first }
      end
    end
  end

  def update
    respond_to do |format|
      if @holiday.update(holiday_params)
        format.html { redirect_to admin_holidays_path(@holiday), notice: I18n.t('active_controller.messages.updated', object_name: I18n.t('holidays.dashboard_name').downcase) }
      else
        format.html { redirect_to admin_holidays_path(@holiday), alert: @holiday.errors.full_messages.first }
      end
    end
  end

  def destroy
    @holiday.destroy

    respond_to do |format|
      format.html { redirect_to admin_holidays_path, notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('users.dashboard_name').downcase) }
      format.json { head :no_content }
    end
  end

  private
  def set_holiday
    @holiday = Holiday.find(params[:id])
  end

  def holiday_params
    params.require(:holiday).permit(:name, :start_date, :end_date, :description, :status)
  end

  def strftime_custom(date)
    date.strftime("%d-%m-%Y")
  end
end