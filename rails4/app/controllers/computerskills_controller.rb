class ComputerskillsController < ApplicationController
  before_filter :authorize
  before_action :set_computerskill, only: [:show, :edit, :update, :destroy]
  
  def index
    @computerskills = Computerskill.all
  end

  def show
    @computerskill = Computerskill.find(params[:id])
  end

  def new
    @computerskill = Computerskill.new
  end
  
  def edit
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
        format.html {redirect_to @computerskillm, notice: 'Computerskill was successfully updated.'}
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
  
  def computerskill_params
    par = params.require(:computerskill).permit(:name, :cstype, :level, :experience, :klang)
    if par[:klang] == nil
      option = Option.find_by_user_id(session[:user_id]) 
      par[:klang] = option.language_id
    end
    return par
  end
end
