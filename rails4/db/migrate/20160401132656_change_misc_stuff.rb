class ChangeMiscStuff < ActiveRecord::Migration
  def change
    add_column :miscstuffs, :weight, :int
    add_column :otherskills, :weight, :int
    drop_table :luzs
  end
end
