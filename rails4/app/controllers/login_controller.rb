class LoginController < ApplicationController
  
  
  def index
  end

  def login_app
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        session[:user_name] = user.name
        option = Option.find_by_user_id(user.id) 
        if option
          language = Language.find_by_id(option.language_id)
          I18n.locale = language.isoname.downcase if language
        end
        redirect_to(:controller => 'loadcurr', :action => "load_last")
      else
        flash.now[:error] = t"Invalid user/password combination"
      end
    end
  end

  
  def logout
    session[:user_id] = nil
    session[:curriculum] = nil
    flash[:notice] = "Logged out"
    redirect_to(:action => "login_app")
  end

end
