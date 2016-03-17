class Option < ActiveRecord::Base
  
  def user_name
    User.find(user_id).name
  end
end
