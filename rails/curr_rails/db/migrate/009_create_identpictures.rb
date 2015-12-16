class CreateIdentpictures < ActiveRecord::Migration
  def self.up
    create_table :identpictures do |t|
      t.column :foto, :binary
      t.column :foto_filename, :string
      t.column :kindetity, :integer  
    end
  end

  def self.down
    drop_table :identpictures
  end
end
