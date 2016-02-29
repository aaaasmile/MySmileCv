class CreateOtherskills < ActiveRecord::Migration
  def self.up
    create_table :otherskills do |t|
      t.column :skill, :text
      t.column :sktype, :string
      t.column :klang, :integer
    end
  end

  def self.down
    drop_table :otherskills
  end
end
