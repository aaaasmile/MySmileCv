class LoginController < ApplicationController
  
  #Layout login is needed because we want to hide all menus
  layout "login"
  
  def index
  end

  def login_app
    session[:user_id] = nil
    if request.post?
      user = User.authenticate(params[:name], params[:password])
      if user
        session[:user_id] = user.id
        redirect_to(:controller => 'curriculum', :action => "list_cmds")
      else
        flash.now[:notice] = "Invalid user/password combination"
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
