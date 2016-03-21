class LanguagesController < ApplicationController
  before_filter :authorize
  before_action :set_language, only: [:show, :edit, :update, :destroy]
   
  def index
    @languages = Language.all
  end

  def show
    @language = Language.find(params[:id])
  end

  def new
    @language = Language.new
  end

  def edit
  end

  def create
    @language = Language.new(language_params)
    respond_to do |format|
      if @language.save
        format.html { redirect_to @language,  notice: 'Language was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
     respond_to do |format|
      if @language.update_attributes(language_params)
        format.html {redirect_to @language, notice: 'Language was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @language.destroy
    respond_to do |format|
      format.html { redirect_to languages_url, notice: 'Language was successfully destroyed.' }
    end
  end

  private
  def set_language
    @language = Language.find(params[:id])
  end
  
  def language_params
    params.require(:language).permit(:isoname)
  end
end
