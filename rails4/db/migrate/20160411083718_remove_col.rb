class RemoveCol < ActiveRecord::Migration
  def change
    remove_column :filecurrsaveds, :kuser
  end
end
