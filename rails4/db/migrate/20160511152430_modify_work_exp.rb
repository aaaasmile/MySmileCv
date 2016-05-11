class ModifyWorkExp < ActiveRecord::Migration
  def change
    add_column :workexperiences, :is_date_to_now, :boolean, default: false
  end
end
