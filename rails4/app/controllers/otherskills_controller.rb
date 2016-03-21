class OtherskillsController < ApplicationController
  before_filter :authorize
  
 before_action :set_otherskill, only: [:show, :edit, :update, :destroy]
  
  def index
    @otherskills = Otherskill.all
  end

  def show
    @otherskill = Otherskill.find(params[:id])
  end

  def new
    @otherskill = Otherskill.new
  end
  
  def edit
  end

  def create
    @otherskill = Otherskill.new(otherskill_params)
    respond_to do |format|
      if @otherskill.save
        format.html { redirect_to @otherskill,  notice: 'Otherskill was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @otherskill.update_attributes(otherskill_params)
        format.html {redirect_to @otherskill, notice: 'Otherskill was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @otherskill.destroy
    respond_to do |format|
      format.html { redirect_to otherskills_url, notice: 'Technology was successfully destroyed.' }
    end
  end
  
  private
  def set_otherskill
    @otherskill = Otherskill.find(params[:id])
  end
  
  def otherskill_params
    par = params.require(:otherskill).permit(:skill, :sktype, :klang)
    if par[:klang] == nil
      option = Option.find_by_user_id(session[:user_id]) 
      par[:klang] = option.language_id
    end
    return par
  end
end
