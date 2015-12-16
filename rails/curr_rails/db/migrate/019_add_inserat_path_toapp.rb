class AddInseratPathToapp < ActiveRecord::Migration
  def self.up
    add_column :destcurrs, :inserat_filename, :string
  end

  def self.down
    remove_column 
  end
end
