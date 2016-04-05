class ModifyOptions < ActiveRecord::Migration
  def change
    add_column :options, :use_only_one_language, :int
  end
end
