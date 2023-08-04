# frozen_string_literal: true

class Admin::AnswersController < Admin::BaseController
  before_action :set_answer, only: [:new, :create, :destroy]

  def summary
    @questions = Question.includes(:user, :answers)
                         .ransack(params[:where])
                         .result
                         .order(created_at: :desc)
                         .paginate(page: params[:page]).per_page(params[:per_page] || 15)
  end

  def show; end

  def create
    @answer = current_user.answers.new(answer_params)
    respond_to do |format|
      if @answer.save
        format.html { redirect_to new_admin_question_answer_path(question_id: @question.id), notice: I18n.t('active_controller.messages.created', object_name: I18n.t('questions.dashboard_name').downcase) }
        format.json { render :show, status: :created, location: @answer }
      else
        format.html { redirect_to new_admin_question_answer_path(question_id: @question.id), alert: I18n.t('active_controller.messages.not_created', object_name: I18n.t('questions.dashboard_name').downcase) }
        format.json { render json: @answer.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy; end

  def new
    @question = Question.includes(:answers).find(params[:question_id])
    @answer = @question.answers.new
  end

  private

  def set_answer
    @question = Question.includes(:answers).find(params[:question_id])
    @answer = params[:id] ? Answer.find(params[:id]) : @question.answers.new
  end

  def answer_params
    params.require(:answer).permit(:content).merge(question: @question)
  end
end
