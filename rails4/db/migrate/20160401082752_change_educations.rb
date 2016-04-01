class ChangeEducations < ActiveRecord::Migration
  def change
    rename_column :educations, :from, :date_from
    rename_column :educations, :to, :date_to
  end
end
