class CreateFilecurrsaveds < ActiveRecord::Migration
  def self.up
    create_table :filecurrsaveds do |t|
      t.column :curr_title, :string
      t.column :curr_filename, :string
      t.column :kuser, :integer
    end
  end

  def self.down
    drop_table :filecurrsaveds
  end
end
