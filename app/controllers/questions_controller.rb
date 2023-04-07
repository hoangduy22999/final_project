# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = current_user.questions.ransack(params[:where]).result.paginate(page: params[:page]).per_page(10)
  end

  def create
    @question = current_user.questions.new(question_params)
    respond_to do |format|
      if @question.save
        format.html { redirect_to questions_path, notice: 'Question was successfully created.' }
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
      format.html { redirect_to questions_path, notice: 'Question was successfully destroyed.' }
    end
  end

  private

  def set_question
    @question = Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:content)
  end
end
