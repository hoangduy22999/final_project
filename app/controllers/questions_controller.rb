# frozen_string_literal: true

class QuestionsController < ApplicationController
  before_action :set_question, only: %i[show update destroy]

  def index
    @questions = current_user.questions.ransack(params[:where]).result.paginate(page: params[:page]).per_page(10)
  end

  def create
    @questions = current_user.questions.new(question_params)
    respond_to do |format|
      if @questions.save
        format.html { redirect_to questions_path, notice: 'Question was successfully created.' }
        format.json { render :show, status: :created, location: @questions }
      else
        flash.now[:error] = @questions.errors.full_messages.first
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @questions.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @question = Question.new
  end

  def show; end

  def update
  end

  def destroy
    @question.destroy

    respond_to do |format|
      format.html { redirect_to questions_path, notice: 'Question was successfully destroyed.' }
      format.json { head :no_content }
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
