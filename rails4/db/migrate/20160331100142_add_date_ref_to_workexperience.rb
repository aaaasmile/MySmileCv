class AddDateRefToWorkexperience < ActiveRecord::Migration
  def change
    rename_column :workexperiences, :from, :date_from
    rename_column :workexperiences, :to, :date_to
  end
end
