class OptionsController < ApplicationController
  before_filter :authorize
  before_action :set_option, only: [:index]

  def index
    @option
  end

  private
  def set_option
    @option = Option.find_by_user_id(session[:user_id]) || Option.new
    @option.user_id = session[:user_id]
  end


end
