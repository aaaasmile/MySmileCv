class WorkexperiencesController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @workexperience_pages, @workexperiences = paginate :workexperiences, :per_page => 10
  end

  def show
    @workexperience = Workexperience.find(params[:id])
  end

  def new
    @languages = Language.find(:all)
    @workexperience = Workexperience.new
  end

  def create
    @languages = Language.find(:all)
    @workexperience = Workexperience.new(params[:workexperience])
    if @workexperience.save
      flash[:notice] = 'Workexperience was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.find(:all)
    @workexperience = Workexperience.find(params[:id])
  end

  def update
    @languages = Language.find(:all)
    @workexperience = Workexperience.find(params[:id])
    if @workexperience.update_attributes(params[:workexperience])
      flash[:notice] = 'Workexperience was successfully updated.'
      redirect_to :action => 'show', :id => @workexperience
    else
      render :action => 'edit'
    end
  end

  def destroy
    Workexperience.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
