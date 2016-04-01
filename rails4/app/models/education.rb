class Education < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})
  
  def info_compact
    "#{date_from},#{date_to},#{title},#{skills},#{organisation},#{level}"
  end
end
