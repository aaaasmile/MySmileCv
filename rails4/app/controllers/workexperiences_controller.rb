class WorkexperiencesController < ApplicationController
  before_filter :authorize
  before_action :set_workexperience, only: [:show, :edit, :update, :destroy]
  
  def index
    option = Option.find_by_user_id(session[:user_id]) 
    if(option && option.use_only_one_language == 1)
      @workexperiences = Workexperience.where(["klang = ?", option.language_id]).order("date_from desc")
    else
      @workexperiences = Workexperience.order("date_from desc").all
    end
  end

  def show
    @workexperience = Workexperience.find(params[:id])
  end

  def new
    @workexperience = Workexperience.new
    set_language
  end

  def edit
  end

  def copy
    workexperience_src = Workexperience.find(params[:id])
    @workexperience = Workexperience.new
    
    @workexperience.date_from = workexperience_src.date_from
    @workexperience.date_to = workexperience_src.date_to
    @workexperience.position = workexperience_src.position
    @workexperience.activities = workexperience_src.activities
    @workexperience.employer = workexperience_src.employer
    @workexperience.sector = workexperience_src.sector
    @workexperience.tag = workexperience_src.tag

    set_language

    render :edit
  end

  def create
    @workexperience = Workexperience.new(workexperience_params)
    respond_to do |format|
      if @workexperience.save
        format.html { redirect_to @workexperience,  notice: 'Work experience was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @workexperience.update_attributes(workexperience_params)
        format.html {redirect_to @workexperience, notice: 'Work experience was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @workexperience.destroy
    respond_to do |format|
      format.html { redirect_to workexperiences_url, notice: 'Work experience was successfully destroyed.' }
    end
  end

  private
  def set_workexperience
    @workexperience = Workexperience.find(params[:id])
  end

  def set_language
    option = Option.find_by_user_id(session[:user_id]) 
    @workexperience.klang = option.language_id
  end
  
  def workexperience_params
    params.require(:workexperience).permit(:date_from, :date_to, :position, :activities, :employer, :sector, :tag, :klang)
  end
end
