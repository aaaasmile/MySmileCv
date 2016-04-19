class MiscstuffsController < ApplicationController
  before_action :set_miscstuff, only: [:show, :edit, :update, :destroy]
  
  def index
    userid = session[:user_id]
    option = Option.find_by_user_id(userid) 
    if(option && option.use_only_one_language == 1)
      @miscstuffs = Miscstuff.where(["klang = ? and user_id = ?", option.language_id, userid]).all
    else
      @miscstuffs = Miscstuff.where(["user_id = ?", userid]).all
    end
  end

  def show
  end

  def new
    @miscstuff = Miscstuff.new
    @miscstuff.mstype = "miscellaneous"
    set_language
  end
  
  def edit
  end

  def copy
    miscstuff_src = Miscstuff.find(params[:id])
    @miscstuff = Miscstuff.new

    @miscstuff.misc = miscstuff_src.misc
    @miscstuff.mstype = miscstuff_src.mstype
    
    set_language

    render :edit
  end

  def create
    @miscstuff = Miscstuff.new(miscstuff_params)
    @miscstuff.user_id = session[:user_id]
    respond_to do |format|
      if @miscstuff.save
        format.html { redirect_to @miscstuff,  notice: t('Miscellaneous was successfully created.')}
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @miscstuff.update_attributes(miscstuff_params)
        format.html {redirect_to @miscstuff, notice: t('Miscellaneous was successfully updated.')}
      else
        format.html { render :edit }
      end
    end
  end

  def destroy
    @miscstuff.destroy
    respond_to do |format|
      format.html { redirect_to miscstuffs_url, notice: t('Miscellaneous was successfully destroyed.') }
    end
  end
  
  private
  def set_miscstuff
    @miscstuff = Miscstuff.find(params[:id])
    @miscstuff = @miscstuff.user_id == session[:user_id] ? @miscstuff : nil
  end

  def set_language
    option = Option.find_by_user_id(session[:user_id]) 
    @miscstuff.klang = option.language_id
  end
  
  def miscstuff_params
    params.require(:miscstuff).permit(:misc, :mstype, :weight, :klang)
  end
end
