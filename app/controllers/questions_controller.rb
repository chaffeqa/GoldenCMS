class QuestionsController < ApplicationController


  def new
    @question = Question.new
  end


  def create
    @question = Question.new(params[:question])
    if @question.save
      QuestionsMailer.question_submital(@question).deliver
      redirect_to(new_question_path, :notice => 'Question was successfully Submitted.')
    else
      render :action => "new"
    end
  end


end

