module EducationsHelper
  def copy_education_path(education)
    url_for controller: 'educations', action: 'copy', id: education.id 
  end
end
