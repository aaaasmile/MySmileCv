class CreateMiscstuffs < ActiveRecord::Migration
  def self.up
    create_table :miscstuffs do |t|
      t.column :misc, :text
      t.column :mstype, :string
      t.column :klang, :integer
    end
  end

  def self.down
    drop_table :miscstuffs
  end
end
