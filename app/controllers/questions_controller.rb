# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show update destroy]
  before_action :read_notification, only: %i[show]

  def index
    @questions = current_user.questions.ransack(params[:where]).result.paginate(page: params[:page]).per_page(10)
    @answers_count = Question.where(id: @questions.pluck(:id)).select("questions.id, count(answers.id) as answer_count").joins(:answers).group("questions.id")
  end

  def create
    @question = current_user.questions.new(question_params)
    respond_to do |format|
      if @question.save
        format.html { redirect_to questions_path, notice: I18n.t('active_controller.messages.created', object_name: I18n.t('questions.dashboard_name').downcase) }
      else
        format.html { redirect_to questions_path, alert: @question.errors.full_messages.first }
      end
    end
  end

  def new
    @question = Question.new
  end

  def show; end

  def update; end

  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_path, notice: I18n.t('active_controller.messages.removed', object_name: I18n.t('questions.dashboard_name').downcase) }
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])

    redirect_to questions_path, alert: I18n.t('toatr.messages.errors.unauthorized') unless @question.user_id.eql?(current_user.id)
  end

  def question_params
    params.require(:question).permit(:content)
  end
  
  def read_notification
    Notification.find_by(id: params[:notification_id])&.read_notification
  end
end
