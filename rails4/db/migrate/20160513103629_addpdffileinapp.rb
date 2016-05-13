class Addpdffileinapp < ActiveRecord::Migration
  def change
    add_column :destcurrs, :pdf_jobinsertion, :text
    add_column :destcurrs, :pdf_cv, :text
  end
end
