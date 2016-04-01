class Languageskill < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{name},#{level}"
  end
  
end
