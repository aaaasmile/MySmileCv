class LanguageskillsController < ApplicationController
  before_filter :authorize
  before_action :set_languageskill, only: [:show, :edit, :update, :destroy]
  
  def index
    @languageskills = Languageskill.all
  end

  def show
    @languageskill = Languageskill.find(params[:id])
  end

  def new
    @languageskill = Languageskill.new
  end

  def create
    @languageskill = Languageskill.new(languageskill_params)
    respond_to do |format|
      if @languageskill.save
        format.html { redirect_to @languageskill,  notice: 'Language skill was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @languageskill.update_attributes(languageskill_params)
        format.html {redirect_to @languageskill, notice: 'Language skill was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @languageskill.destroy
    respond_to do |format|
      format.html { redirect_to languageskills_url, notice: 'Technology was successfully destroyed.' }
    end
  end
  
  private
  def set_languageskill
    @languageskill = Languageskill.find(params[:id])
  end
  
  def languageskill_params
    par = params.require(:languageskill).permit(:name, :level, :lang, :klang)
    if par[:klang] == nil
      option = Option.find_by_user_id(session[:user_id]) 
      par[:klang] = option.language_id
    end
    return par
  end


end
