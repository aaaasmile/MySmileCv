# La ragione di questo cambiamento (uso sqlite):
#Uploading files to a SQLite database
# You can't store things with null bytes into BLOBs yet. 
# Until the new adapter is out, use Base64 or some similar 
# binary coding system to make it not contain null bytes.


class ChangePictureType < ActiveRecord::Migration
  def self.up
    remove_column :identpictures, :foto
    add_column :identpictures, :foto, :text
  end

  def self.down
  end
end
