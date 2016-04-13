class OptionsController < ApplicationController
  before_filter :authorize
  before_action :set_option, only: [:index, :update]

  def index
    if @option == nil
      new()
      render :new 
    else
      render :edit
    end
  end

  def edit
  end

  def new
    @option = Option.new
    @option.user_id = session[:user_id]
  end

  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        update_locale
        format.html { redirect_to curriculum_url, notice: 'Option was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  def update
    respond_to do |format|
      if @option.update(option_params)
        update_locale
        format.html { redirect_to curriculum_url, notice: 'Option was successfully updated.' }
      else
        format.html { render :edit }
      end
    end
  end

  private
  def set_option
    @option = Option.find_by_user_id(session[:user_id]) 
  end

  def update_locale
    language = Language.find_by_id(@option.language_id)
    I18n.locale = language.isoname.downcase if language
  end

  def option_params
    params.require(:option).permit(:user_id, :language_id, :use_only_one_language)
  end

end
