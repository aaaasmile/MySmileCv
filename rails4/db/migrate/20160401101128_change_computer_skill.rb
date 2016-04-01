class ChangeComputerSkill < ActiveRecord::Migration
  def change
    add_column :computerskills, :weight, :int
  end
end
