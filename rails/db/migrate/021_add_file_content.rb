class AddFileContent < ActiveRecord::Migration
  def self.up
	add_column :filecurrsaveds, :content, :text
  end

  def self.down
	remove_column :filecurrsaveds, :content
  end
end
