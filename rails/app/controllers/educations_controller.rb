class EducationsController < ApplicationController
  before_filter :authorize
  
  def index
    list
    render :action => 'list'
  end

  # GETs should be safe (see http://www.w3.org/2001/tag/doc/whenToUseGet.html)
  verify :method => :post, :only => [ :destroy, :create, :update ],
         :redirect_to => { :action => :list }

  def list
    @education_pages, @educations = paginate :educations, :per_page => 10
  end

  def show
    @languages = Language.find(:all)
    @education = Education.find(params[:id])
  end

  def new
    @languages = Language.find(:all)
    @education = Education.new
  end

  def create
    @languages = Language.find(:all)
    @education = Education.new(params[:education])
    if @education.save
      flash[:notice] = 'Education was successfully created.'
      redirect_to :action => 'list'
    else
      render :action => 'new'
    end
  end

  def edit
    @languages = Language.find(:all)
    @education = Education.find(params[:id])
  end

  def update
    @languages = Language.find(:all)
    @education = Education.find(params[:id])
    if @education.update_attributes(params[:education])
      flash[:notice] = 'Education was successfully updated.'
      redirect_to :action => 'show', :id => @education
    else
      render :action => 'edit'
    end
  end

  def destroy
    Education.find(params[:id]).destroy
    redirect_to :action => 'list'
  end
end
