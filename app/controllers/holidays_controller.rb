class HolidaysController < ApplicationController
  before_action :set_holiday, only: %i[update show destroy]

  def index
    @holidays = Holiday.ransack(params[:where]).result.order(start_date: :desc).paginate(page: params[:page]).per_page(10)
  end

  def new
    @holiday = Holiday.new
  end

  def show; end

  def create
    @holiday = Holiday.new(holiday_params)
    respond_to do |format|
      if cannot? :create, @holiday
        format.html { redirect_to holidays_path(@holiday), alert: "Permission denied" }
      elsif @holiday.save
        format.html { redirect_to holidays_path(@holiday), notice: 'Holiday was successfully created.' }
      else
        format.html { redirect_to holidays_path(@holiday), alert: @holiday.errors.full_messages.first }
      end
    end
  end

  def update
    respond_to do |format|
      if @holiday.update(holiday_params)
        format.html { redirect_to holidays_path(@holiday), notice: 'Holiday was successfully updated.' }
      else
        format.html { redirect_to holidays_path(@holiday), alert: @holiday.errors.full_messages.first }
      end
    end
  end

  def destroy
    @holiday.destroy

    respond_to do |format|
      format.html { redirect_to holidays_path, notice: 'Holiday was successfully destroyed.' }
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
end