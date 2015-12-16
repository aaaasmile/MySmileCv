class AddColumnIdentity < ActiveRecord::Migration
  def self.up
    add_column :identities, :familystate, :string
  end

  def self.down
    remove_column :identities, :familystate
  end
end
