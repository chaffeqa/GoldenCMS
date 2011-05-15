class Admin::QuestionsController < ApplicationController
  layout 'admin'
  before_filter :check_admin

  def index
    @questions = Question.page(@page).per(@per_page)
    @questions = @questions.order(@sort + " " + @direction) unless @sort.blank?
  end

  def show
    @question = Question.find(params[:id])
  end

  def destroy
    @question = Question.find(params[:id])
    @question.destroy
    redirect_to(admin_questions_url, :notice => 'Client messege was successfully destroyed.' )
  end
end
