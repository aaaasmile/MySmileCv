class ComputerskillsController < ApplicationController
  before_filter :authorize
  before_action :set_computerskill, only: [:show, :edit, :update, :destroy]
  
  def index
    option = Option.find_by_user_id(session[:user_id]) 
    if(option && option.use_only_one_language == 1)
      @computerskills = Computerskill.where(["klang = ?", option.language_id]).order("weight desc").all
    else
      @computerskills = Computerskill.order("weight desc").all
    end
  end

  def show
    @computerskill = Computerskill.find(params[:id])
  end

  def new
    @computerskill = Computerskill.new
    set_language
  end
  
  def edit
  end

  def copy
    computerskill_src = Computerskill.find(params[:id])
    @computerskill = Computerskill.new
    @computerskill.name = computerskill_src.name
    @computerskill.cstype = computerskill_src.cstype
    @computerskill.level = computerskill_src.level
    @computerskill.experience = computerskill_src.experience

    set_language

    render :edit
  end

  def create
    @computerskill = Computerskill.new(computerskill_params)
    respond_to do |format|
      if @computerskill.save
        format.html { redirect_to @computerskill,  notice: 'Computerskill was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @computerskill.update_attributes(computerskill_params)
        format.html {redirect_to @computerskill, notice: 'Computerskill was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @computerskill.destroy
    respond_to do |format|
      format.html { redirect_to computerskills_url, notice: 'Technology was successfully destroyed.' }
    end
  end
  
  private
  def set_computerskill
    @computerskill = Computerskill.find(params[:id])
  end

  def set_language
    option = Option.find_by_user_id(session[:user_id]) 
    @computerskill.klang = option.language_id
  end
  
  def computerskill_params
    params.require(:computerskill).permit(:name, :cstype, :level, :experience, :klang, :weight)
  end
end
