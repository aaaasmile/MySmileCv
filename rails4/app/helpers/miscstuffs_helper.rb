module MiscstuffsHelper
  def copy_miscstuff_path(miscstuff)
    url_for controller: 'miscstuffs', action: 'copy', id: miscstuff.id 
  end
end
