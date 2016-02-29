class ChangetypeCumputerskill < ActiveRecord::Migration
  def self.up
    rename_column :computerskills, :type, :cstype
  end

  def self.down
    rename_column :computerskills, :cstype, :type 
  end
end
