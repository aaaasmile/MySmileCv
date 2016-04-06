# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def user_signed_in?
    return session[:user_id] != nil
  end

  def new_user_session_path
    url_for controller: 'login', action: 'login_app'
  end

  def destroy_user_session_path
    url_for controller: 'login', action: 'logout'
  end
end
