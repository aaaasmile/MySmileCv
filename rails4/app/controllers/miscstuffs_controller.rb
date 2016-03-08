class MiscstuffsController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  def list
    @miscstuff_pages, @miscstuffs = paginate :miscstuffs, :per_page => 10
  end

  def show
    @miscstuff = Miscstuff.find(params[:id])
  end

  def new
    @languages = Language.find(:all)
    @miscstuff = Miscstuff.new
  end

  def create
    @languages = Language.find(:all)
    @miscstuff = Miscstuff.new(params[:miscstuff])
    if @miscstuff.save
      flash[:notice] = 'Miscstuff was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.find(:all)
    @miscstuff = Miscstuff.find(params[:id])
  end

  def update
    @languages = Language.find(:all)
    @miscstuff = Miscstuff.find(params[:id])
    if @miscstuff.update_attributes(params[:miscstuff])
      flash[:notice] = 'Miscstuff was successfully updated.'
      redirect_to :action => 'show', :id => @miscstuff
    else
      render :action => 'edit'
    end
  end

  def destroy
    Miscstuff.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
