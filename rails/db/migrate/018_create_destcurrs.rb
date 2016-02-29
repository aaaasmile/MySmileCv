class CreateDestcurrs < ActiveRecord::Migration
  def self.up
    create_table :destcurrs do |t|
      t.column :inserat, :text   # testo dell'inserzione
      t.column :contact_email, :string
      t.column :contact_web, :string
      t.column :contact_person, :string
      t.column :contact_company, :string
      t.column :contact_note, :text # info sull'inserzione
      t.column :contact_ams, :boolean # contatto dato da ams
      t.column :curr_sent_at, :date
      t.column :colloquio_at, :date
      t.column :email_motivaz, :text
      t.column :note, :text
      t.column :risultato, :string
      t.column :kcurr_saved, :integer
    end
  end

  def self.down
    drop_table :destcurrs
  end
end
