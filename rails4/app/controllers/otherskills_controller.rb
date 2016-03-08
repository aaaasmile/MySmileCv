class OtherskillsController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  def list
    @otherskill_pages, @otherskills = paginate :otherskills, :per_page => 10
  end

  def show
    @otherskill = Otherskill.find(params[:id])
  end

  def new
    @languages = Language.find(:all)
    @otherskill = Otherskill.new
  end

  def create
    @languages = Language.find(:all)
    @otherskill = Otherskill.new(params[:otherskill])
    if @otherskill.save
      flash[:notice] = 'Otherskill was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.find(:all)
    @otherskill = Otherskill.find(params[:id])
  end

  def update
    @languages = Language.find(:all)
    @otherskill = Otherskill.find(params[:id])
    if @otherskill.update_attributes(params[:otherskill])
      flash[:notice] = 'Otherskill was successfully updated.'
      redirect_to :action => 'show', :id => @otherskill
    else
      render :action => 'edit'
    end
  end

  def destroy
    Otherskill.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
