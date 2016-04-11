class EducationsController < ApplicationController
  before_filter :authorize
  before_action :set_education, only: [:show, :edit, :update, :destroy]
  
  def index
    userid = session[:user_id]
    option = Option.find_by_user_id(userid) 
    if(option && option.use_only_one_language == 1)
      @educations = Education.where(["klang = ? and user_id = ?", option.language_id, userid]).order("date_from desc")
    else
      @educations = Education.where(["user_id = ?", userid]).order("date_from desc").all
    end
  end

  def show
    @education = Education.find(params[:id])
    @education = @education.user_id == session[:user_id] ? @education : nil
  end

  def new
    @education = Education.new
    set_language
  end

  def edit
  end

  def copy
    education_src = Education.find(params[:id])
    @education = Education.new
    
    @education.date_from = education_src.date_from
    @education.date_to = education_src.date_to
    @education.title = education_src.title
    @education.skills = education_src.skills
    @education.organisation = education_src.organisation
    @education.level = education_src.level

    set_language

    render :edit
  end

  def create
    @education = Education.new(education_params)
    @education.user_id = session[:user_id]
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

  def set_language
    option = Option.find_by_user_id(session[:user_id]) 
    @education.klang = option.language_id
  end
  
  def education_params
    params.require(:education).permit(:date_from, :date_to, :title, :skills, :organisation, :level, :klang)
  end
end
