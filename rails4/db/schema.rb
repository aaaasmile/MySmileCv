# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20160413074748) do

  create_table "computerskills", force: :cascade do |t|
    t.string  "name",       limit: 255
    t.string  "cstype",     limit: 255
    t.string  "level",      limit: 255
    t.string  "experience", limit: 255
    t.integer "klang"
    t.integer "weight"
    t.integer "user_id"
  end

  add_index "computerskills", ["user_id"], name: "computerskills_on_user_id"

  create_table "destcurrs", force: :cascade do |t|
    t.text    "inserat"
    t.string  "contact_email",    limit: 255
    t.string  "contact_web",      limit: 255
    t.string  "contact_person",   limit: 255
    t.string  "contact_company",  limit: 255
    t.text    "contact_note"
    t.boolean "contact_ams"
    t.date    "curr_sent_at"
    t.date    "colloquio_at"
    t.text    "email_motivaz"
    t.text    "note"
    t.string  "risultato",        limit: 255
    t.integer "kcurr_saved"
    t.string  "inserat_filename", limit: 255
    t.integer "user_id"
  end

  add_index "destcurrs", ["user_id"], name: "destcurrs_on_user_id"

  create_table "educations", force: :cascade do |t|
    t.date    "date_from"
    t.date    "date_to"
    t.string  "title",        limit: 255
    t.text    "skills"
    t.string  "organisation", limit: 255
    t.string  "level",        limit: 255
    t.integer "klang"
    t.integer "user_id"
  end

  add_index "educations", ["user_id"], name: "educations_on_user_id"

  create_table "filecurrsaveds", force: :cascade do |t|
    t.string  "curr_title",    limit: 255
    t.string  "curr_filename", limit: 255
    t.text    "content"
    t.integer "user_id"
  end

  add_index "filecurrsaveds", ["user_id"], name: "filecurrsaveds_on_user_id"

  create_table "identities", force: :cascade do |t|
    t.string  "firstname",   limit: 255
    t.string  "lastname",    limit: 255
    t.string  "address",     limit: 255
    t.string  "mobile",      limit: 255
    t.string  "email",       limit: 255
    t.string  "web",         limit: 255
    t.date    "birthdate"
    t.string  "gender",      limit: 255
    t.string  "nationality", limit: 255
    t.integer "klang"
    t.string  "familystate", limit: 255
    t.string  "other"
    t.string  "codice_fisc"
    t.integer "user_id"
  end

  add_index "identities", ["user_id"], name: "identities_on_user_id"

  create_table "identpictures", force: :cascade do |t|
    t.string  "foto_filename", limit: 255
    t.string  "content_type",  limit: 255
    t.text    "foto"
    t.integer "user_id"
  end

  add_index "identpictures", ["user_id"], name: "identpictures_on_user_id"

  create_table "languages", force: :cascade do |t|
    t.string "isoname", limit: 255
  end

  create_table "languageskills", force: :cascade do |t|
    t.string  "name",    limit: 255
    t.string  "level",   limit: 255
    t.integer "klang"
    t.integer "user_id"
  end

  add_index "languageskills", ["user_id"], name: "languageskills_on_user_id"

  create_table "miscstuffs", force: :cascade do |t|
    t.text    "misc"
    t.string  "mstype",  limit: 255
    t.integer "klang"
    t.integer "weight"
    t.integer "user_id"
  end

  add_index "miscstuffs", ["user_id"], name: "miscstuffs_on_user_id"

  create_table "options", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "language_id"
    t.datetime "created_at",            null: false
    t.datetime "updated_at",            null: false
    t.integer  "use_only_one_language"
  end

  create_table "otherskills", force: :cascade do |t|
    t.text    "skill"
    t.string  "sktype",  limit: 255
    t.integer "klang"
    t.integer "weight"
    t.integer "user_id"
  end

  add_index "otherskills", ["user_id"], name: "otherskills_on_user_id"

  create_table "schema_info", id: false, force: :cascade do |t|
    t.integer "version"
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", limit: 255
    t.text     "data"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], name: "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], name: "index_sessions_on_updated_at"

  create_table "users", force: :cascade do |t|
    t.string "name",            limit: 255
    t.string "hashed_password", limit: 255
    t.string "salt",            limit: 255
  end

  create_table "workexperiences", force: :cascade do |t|
    t.date    "date_from"
    t.date    "date_to"
    t.string  "position",   limit: 255
    t.text    "activities"
    t.text    "employer"
    t.string  "sector",     limit: 255
    t.string  "tag",        limit: 255
    t.integer "klang"
    t.integer "user_id"
  end

  add_index "workexperiences", ["user_id"], name: "workexperiences_on_user_id"

end
