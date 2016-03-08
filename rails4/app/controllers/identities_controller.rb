class IdentitiesController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  def list
    @identity_pages, @identities = paginate :identities, :per_page => 10
  end

  def show
    @identity = Identity.find(params[:id])
  end

  def new
    @languages = Language.find(:all)
    @identity = Identity.new
  end

  def create
    @languages = Language.find(:all)
    @identity = Identity.new(params[:identity])
    if @identity.save
      flash[:notice] = 'Identity was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.find(:all)
    @identity = Identity.find(params[:id])
  end

  def update
    @languages = Language.find(:all)
    @identity = Identity.find(params[:id])
    if @identity.update_attributes(params[:identity])
      flash[:notice] = 'Identity was successfully updated.'
      redirect_to :action => 'show', :id => @identity
    else
      render :action => 'edit'
    end
  end

  def destroy
    Identity.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
