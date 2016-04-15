class RemoveColLevel < ActiveRecord::Migration
  def change
    remove_column :educations, :level
  end
end
