class ChangeDestcurr < ActiveRecord::Migration
  def change
    add_column :destcurrs, :pdf_cv_filename, :string
    remove_column :destcurrs, :kcurr_saved
    rename_column :destcurrs, :inserat, :job_descr
  end
end
