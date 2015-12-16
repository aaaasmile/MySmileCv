class CreateComputerskills < ActiveRecord::Migration
  def self.up
    create_table :computerskills do |t|
        t.column :name, :string
        t.column :cstype, :string
        t.column :level, :string
        t.column :experience, :string
        t.column :klang, :integer
    end
  end

  def self.down
    drop_table :computerskills
  end
end
