class Workexperience < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{from},#{to},#{position},#{activities},#{employer},#{sector}"
  end
end
