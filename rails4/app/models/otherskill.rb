class Otherskill < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{skill},#{sktype}"
  end

  def get_always_weight
    self.weight != nil ? self.weight : 0
  end
  
end
