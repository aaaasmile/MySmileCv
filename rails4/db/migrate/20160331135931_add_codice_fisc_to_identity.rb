class AddCodiceFiscToIdentity < ActiveRecord::Migration
  def change
    add_column :identities, :codice_fisc, :string
  end
end
