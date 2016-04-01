module ComputerskillsHelper
  def copy_computerskill_path(computerskill)
    url_for controller: 'computerskills', action: 'copy', id: computerskill.id 
  end
end
