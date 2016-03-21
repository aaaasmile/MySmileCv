class EducationsController < ApplicationController
  before_filter :authorize
  before_action :set_education, only: [:show, :edit, :update, :destroy]
  
  def index
    @educations = Education.all
  end

  def show
    @education = Education.find(params[:id])
  end

  def new
    @education = Education.new
  end

  def edit
  end

  def create
    @education = Education.new(education_params)
    respond_to do |format|
      if @education.save
        format.html { redirect_to @education,  notice: 'Education was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @education.update_attributes(education_params)
        format.html {redirect_to @education, notice: 'Education was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @education.destroy
    respond_to do |format|
      format.html { redirect_to educations_url, notice: 'Education was successfully destroyed.' }
    end
  end

  private
  def set_education
    @education = Education.find(params[:id])
  end
  
  def education_params
    par = params.require(:education).permit(:from, :to, :title, :skills, :organisation, :level, :klang)
    if par[:klang] == nil
      option = Option.find_by_user_id(session[:user_id]) 
      par[:klang] = option.language_id
    end
    return par
  end
end
