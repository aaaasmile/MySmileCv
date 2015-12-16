class CreateEducations < ActiveRecord::Migration
  def self.up
    create_table :educations do |t|
      	t.column :from, :date
        t.column :to, :date
        t.column :title, :string
        t.column :skills, :text
        t.column :organisation, :string
        t.column :level, :string
        t.column :klang, :integer
    end
  end

  def self.down
    drop_table :educations
  end
end
