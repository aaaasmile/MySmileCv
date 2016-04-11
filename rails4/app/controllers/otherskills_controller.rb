class OtherskillsController < ApplicationController
  before_filter :authorize
  
 before_action :set_otherskill, only: [:show, :edit, :update, :destroy]
  
  def index
    userid = session[:user_id]
    option = Option.find_by_user_id(userid) 
    if(option && option.use_only_one_language == 1)
      @otherskills = Otherskill.where(["klang = ? and user_id = ?", option.language_id, userid]).all
    else
      @otherskills = Otherskill.where(["user_id = ?", userid]).all
    end
  end

  def show
  end

  def new
    @otherskill = Otherskill.new
  end
  
  def edit
  end

  def create
    @otherskill = Otherskill.new(otherskill_params)
    @otherskill.user_id = session[:user_id]
    @otherskill.sktype = 'Hobby' #Other skills are only hobbies
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
    @otherskill = @otherskill.user_id == session[:user_id] ? @otherskill : nil
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
