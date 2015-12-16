class CreateWorkexperiences < ActiveRecord::Migration
  def self.up
    create_table :workexperiences do |t|
        t.column :from, :date
        t.column :to, :date
        t.column :position, :string
        t.column :activities, :text
        t.column :employer, :text
        t.column :sector, :string
        t.column :tag, :string
        t.column :klang, :integer
    end
  end

  def self.down
    drop_table :workexperiences
  end
end
