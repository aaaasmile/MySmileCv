class OptionsController < ApplicationController
  before_filter :authorize
  before_action :set_option, only: [:index]

  def index
  end

  def create
    @option = Option.new(option_params)

    respond_to do |format|
      if @option.save
        format.html { redirect_to curriculum_url, notice: 'Option was successfully created.' }
      else
        format.html { render :new }
      end
    end
  end

  private
  def set_option
    p @option = Option.find_by_user_id(session[:user_id]) || Option.new
    @option.user_id = session[:user_id]
  end

  def option_params
    params.require(:option).permit(:user_id, :language_id)
  end

end
