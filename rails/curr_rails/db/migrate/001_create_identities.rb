class CreateIdentities < ActiveRecord::Migration
  def self.up
    create_table :identities do |t|
      	t.column :firstname, :string
        t.column :lastname, :string
        t.column :address, :string
        t.column :fax, :string
        t.column :mobile, :string
        t.column :email, :string
        t.column :web, :string
        t.column :birthdate, :date
        t.column :gender, :string
        t.column :nationality, :string
        t.column :klang, :integer
    end
  end

  def self.down
    drop_table :identities
  end
end
