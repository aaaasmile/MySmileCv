class Workexperience < ActiveRecord::Base
  belongs_to(:language, {:foreign_key => 'klang'})

  attr_reader :cumulated_activities
  
  def info_compact
    "#{date_from},#{date_to},#{position},#{activities},#{employer},#{sector}"
  end

  def set_cumulated_activities(arr_act)
    @cumulated_activities = arr_act || []
  end
end
