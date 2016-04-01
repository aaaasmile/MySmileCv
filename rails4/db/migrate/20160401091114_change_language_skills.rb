class ChangeLanguageSkills < ActiveRecord::Migration
  def change
    remove_column :languageskills, :lang
  end
end
