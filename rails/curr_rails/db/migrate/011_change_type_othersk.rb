class ChangeTypeOthersk < ActiveRecord::Migration
  def self.up
    rename_column :otherskills, :type, :sktype
  end

  def self.down
    rename_column :otherskills, :sktype, :type 
  end
end
