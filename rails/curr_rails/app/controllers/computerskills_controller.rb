class ComputerskillsController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @computerskill_pages, @computerskills = paginate :computerskills, :per_page => 10
  end

  def show
    @computerskill = Computerskill.find(params[:id])
  end

  def new
    @languages = Language.find(:all)
    @computerskill = Computerskill.new
  end

  def create
    @languages = Language.find(:all)
    @computerskill = Computerskill.new(params[:computerskill])
    if @computerskill.save
      flash[:notice] = 'Computerskill was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.find(:all)
    @computerskill = Computerskill.find(params[:id])
  end

  def update
    @languages = Language.find(:all)
    @computerskill = Computerskill.find(params[:id])
    if @computerskill.update_attributes(params[:computerskill])
      flash[:notice] = 'Computerskill was successfully updated.'
      redirect_to :action => 'show', :id => @computerskill
    else
      render :action => 'edit'
    end
  end

  def destroy
    Computerskill.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
