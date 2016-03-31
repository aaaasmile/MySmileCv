class AddDateRefToWorkexperience < ActiveRecord::Migration
  def change
    add_column :workexperiences, :date_ref, :date
  end
end
