module WorkexperiencesHelper
  def copy_workexperience_path(workexperience)
    url_for controller: 'workexperiences', action: 'copy', id: workexperience.id 
  end
end
