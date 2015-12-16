class Education < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{from},#{to},#{title},#{skills},#{organisation},#{level}"
  end
end
