class LanguageskillsController < ApplicationController
  before_filter :authorize
  before_action :set_languageskill, only: [:show, :edit, :update, :destroy]
  
  def index
    userid = session[:user_id]
    option = Option.find_by_user_id(userid) 
    if(option && option.use_only_one_language == 1)
      @languageskills = Languageskill.where(["klang = ? and user_id = ?", option.language_id, userid]).all
    else
      @languageskills = Languageskill.where(["user_id = ?", userid]).all
    end
  end

  def show
  end

  def edit
  end

  def new
    @languageskill = Languageskill.new
    set_language
  end

  def create
    @languageskill = Languageskill.new(languageskill_params)
    @languageskill.user_id = session[:user_id]
    respond_to do |format|
      if @languageskill.save
        format.html { redirect_to @languageskill,  notice: t('Language was successfully created.')}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @languageskill.update_attributes(languageskill_params)
        format.html {redirect_to @languageskill, notice: t('Language was successfully updated.')}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @languageskill.destroy
    respond_to do |format|
      format.html { redirect_to languageskills_url, notice: t('Language was successfully destroyed.')}
    end
  end
  
  private
  def set_languageskill
    @languageskill = Languageskill.find(params[:id])
    @languageskill = @languageskill.user_id == session[:user_id] ? @languageskill : nil
  end

  def set_language
    option = Option.find_by_user_id(session[:user_id]) 
    @languageskill.klang = option.language_id
  end
  
  def languageskill_params
    params.require(:languageskill).permit(:name, :level, :lang, :klang)
  end


end
