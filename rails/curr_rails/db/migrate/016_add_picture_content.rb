class AddPictureContent < ActiveRecord::Migration
  def self.up
    add_column :identpictures, :content_type, :string
  end

  def self.down
    remove_column :identpictures, :content_type
  end
end
