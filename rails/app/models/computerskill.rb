class Computerskill < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{name},#{cstype},#{level},#{experience}"
  end
  
end
