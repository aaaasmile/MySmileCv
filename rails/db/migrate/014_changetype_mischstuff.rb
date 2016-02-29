class ChangetypeMischstuff < ActiveRecord::Migration
  def self.up
    rename_column :miscstuffs, :type, :mstype
  end

  def self.down
    rename_column :miscstuffs, :mstype, :type 
  end
end
