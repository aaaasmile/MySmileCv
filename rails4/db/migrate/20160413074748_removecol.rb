class Removecol < ActiveRecord::Migration
  def change
    remove_column :identpictures, :kindetity
  end
end
