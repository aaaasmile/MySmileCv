class CreateLuzs < ActiveRecord::Migration
  def change
    create_table :luzs do |t|

      t.timestamps null: false
    end
  end
end
