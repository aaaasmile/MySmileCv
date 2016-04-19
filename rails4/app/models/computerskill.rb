class Computerskill < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{name},#{cstype},#{level},#{experience}"
  end

  def get_always_weight
    self.weight != nil ? self.weight : 0
  end
  
end
