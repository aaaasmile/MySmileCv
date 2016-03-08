class LanguageskillsController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  def list
    @languageskill_pages, @languageskills = paginate :languageskills, :per_page => 10
  end

  def show
    @languageskill = Languageskill.find(params[:id])
  end

  def new
    @languages = Language.find(:all)
    @languageskill = Languageskill.new
  end

  def create
    @languages = Language.find(:all)
    @languageskill = Languageskill.new(params[:languageskill])
    if @languageskill.save
      flash[:notice] = 'Languageskill was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.find(:all)
    @languageskill = Languageskill.find(params[:id])
  end

  def update
    @languages = Language.find(:all)
    @languageskill = Languageskill.find(params[:id])
    if @languageskill.update_attributes(params[:languageskill])
      flash[:notice] = 'Languageskill was successfully updated.'
      redirect_to :action => 'show', :id => @languageskill
    else
      render :action => 'edit'
    end
  end

  def destroy
    Languageskill.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
