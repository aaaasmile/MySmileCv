class ComputerskillsController < ApplicationController
  before_filter :authorize
  before_action :set_computerskill, only: [:show, :edit, :update, :destroy]
  
  def index
    @computerskills = Computerskill.all
  end

  def show
    @computerskill = Computerskill.find(params[:id])
  end

  def new
    @computerskill = Computerskill.new
  end
  
  def edit
  end


  def create
    @computerskill = Computerskill.new(computerskill_params)
    if @computerskill.save
      flash[:notice] = 'Computerskill was successfully created.'
      redirect_to @computerskill
    else
      render :new
    end
  end

  def update
    if @computerskill.update_attributes(computerskill_params)
      flash[:notice] = 'Computerskill was successfully updated.'
      redirect_to @computerskill
    else
      render :edit
    end
  end

  def destroy
    @computerskill.destroy
    flash[:notice] = 'Computerskill was successfully destroyed'
    redirect_to_computerskill_url
  end
  
  private
  def set_computerskill
    @computerskill = Computerskill.find(params[:id])
  end
  
  def computerskill_params
    params.require(:computerskill).permit()
  end
end
