class CreateLanguageskills < ActiveRecord::Migration
  def self.up
    create_table :languageskills do |t|
        t.column :name, :string
        t.column :level, :string
        t.column :lang, :string
        t.column :klang, :integer
    end
  end

  def self.down
    drop_table :languageskills
  end
end
