# frozen_string_literal: true

class Admin::AnswersController < Admin::BaseController
  before_action :set_answer, only: [:destroy]

  def index
    @questions = Question.ransack(params[:where]).result.paginate(page: params[:page]).per_page(10)
  end

  def show; end

  def create
    @answer = current_user.answers.new(answer_params)
    respond_to do |format|
      if @answer.save
        format.html { redirect_to new_answer_path(@answer.question), notice: I18n.t('active_controller.messages.created', object_name: I18n.t('questions.dashboard_name').downcase) }
        format.json { render :show, status: :created, location: @answer }
      else
        flash.now[:error] = @answer.errors.full_messages.first
        format.html { redirect_to new_answer_path(@answer.question), alert: I18n.t('active_controller.messages.not_created', object_name: I18n.t('questions.dashboard_name').downcase) }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy; end

  def new
    @question = Question.includes(:answers).find(params[:format])
    @answer = Answer.new
  end

  private

  def set_answer
    @answer = Answer.find(params[:id])
  end

  def answer_params
    params.require(:answer).permit(:question_id, :content)
  end
end
