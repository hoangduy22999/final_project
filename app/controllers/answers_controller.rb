class AnswersController < ApplicationController
  private
  
  def set_answer
    @answer = Answer.find(params[:id])
  end
end