class ChangeIdentities < ActiveRecord::Migration
  def change
    remove_column :identities, :fax, :string
    add_column :identities, :other, :string
  end
end
