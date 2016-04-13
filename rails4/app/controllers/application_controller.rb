class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  
  #Pick a unique cookie name to distinguish our session data from others'
  #session :session_key => '_curr_rails_session_id'
  
  def set_locale
    if params[:locale]
      I18n.locale = params[:locale]
    end
  end

  def default_url_options(options = {})
    { locale: I18n.locale }.merge options
  end

  def authorize
     unless User.find_by_id(session[:user_id])
       flash[:notice] = "Please log in"
       redirect_to(:controller => "login" , :action => "login_app" )
    end
  end

end
