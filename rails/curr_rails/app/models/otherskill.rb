class Otherskill < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{skill},#{sktype}"
  end
  
end
