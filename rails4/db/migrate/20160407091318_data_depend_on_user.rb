class DataDependOnUser < ActiveRecord::Migration
  def change
    add_column :computerskills, :user_id, :integer
    add_column :destcurrs, :user_id, :integer
    add_column :educations, :user_id, :integer
    add_column :filecurrsaveds, :user_id, :integer
    add_column :identities, :user_id, :integer
    add_column :identpictures, :user_id, :integer
    add_column :languageskills, :user_id, :integer
    add_column :miscstuffs, :user_id, :integer
    add_column :otherskills, :user_id, :integer
    add_column :workexperiences, :user_id, :integer

    add_index "computerskills", ["user_id"], name: "computerskills_on_user_id"
    add_index "destcurrs", ["user_id"], name: "destcurrs_on_user_id"
    add_index "educations", ["user_id"], name: "educations_on_user_id"
    add_index "filecurrsaveds", ["user_id"], name: "filecurrsaveds_on_user_id"
    add_index "identities", ["user_id"], name: "identities_on_user_id"
    add_index "identpictures", ["user_id"], name: "identpictures_on_user_id"
    add_index "languageskills", ["user_id"], name: "languageskills_on_user_id"
    add_index "miscstuffs", ["user_id"], name: "miscstuffs_on_user_id"
    add_index "otherskills", ["user_id"], name: "otherskills_on_user_id"
    add_index "workexperiences", ["user_id"], name: "workexperiences_on_user_id"
  end
end
