class MiscstuffsController < ApplicationController
  before_action :set_miscstuff, only: [:show, :edit, :update, :destroy]
  
  def index
    @miscstuffs = Miscstuff.all
  end

  def show
    @miscstuff = Miscstuff.find(params[:id])
  end

  def new
    @miscstuff = Miscstuff.new
  end
  
  def edit
  end

  def create
    @miscstuff = Miscstuff.new(miscstuff_params)
    respond_to do |format|
      if @miscstuff.save
        format.html { redirect_to @miscstuff,  notice: 'Mis. cstuff was successfully created.'}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @miscstuff.update_attributes(miscstuff_params)
        format.html {redirect_to @miscstuff, notice: 'Misc. stuff was successfully updated.'}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @miscstuff.destroy
    respond_to do |format|
      format.html { redirect_to miscstuffs_url, notice: 'Misc. stuff was successfully destroyed.' }
    end
  end
  
  private
  def set_miscstuff
    @miscstuff = Miscstuff.find(params[:id])
  end
  
  def miscstuff_params
    par = params.require(:miscstuff).permit(:misc, :mstype, :klang)
    if par[:klang] == nil
      option = Option.find_by_user_id(session[:user_id]) 
      par[:klang] = option.language_id
    end
    return par
  end
end
