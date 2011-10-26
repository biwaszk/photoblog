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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20110401192746) do

  create_table "contexts", :force => true do |t|
    t.integer  "photo_id"
    t.integer  "tag_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contexts", ["photo_id", "tag_id"], :name => "index_contexts_on_photo_id_and_tag_id", :unique => true
  add_index "contexts", ["photo_id"], :name => "index_contexts_on_photo_id"
  add_index "contexts", ["tag_id"], :name => "index_contexts_on_tag_id"

  create_table "edges", :force => true do |t|
    t.text     "edge_extent"
    t.text     "edge_intent"
    t.integer  "concept_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "edges", ["concept_id"], :name => "index_edges_on_concept_id"

  create_table "flags", :force => true do |t|
    t.string   "flag_name"
    t.boolean  "flag_value", :default => false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "flags", ["flag_name"], :name => "index_flags_on_flag_name", :unique => true

  create_table "lattices", :force => true do |t|
    t.text     "concept_extent"
    t.text     "concept_intent"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "photos", :force => true do |t|
    t.string   "file_name"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "photos", ["file_name"], :name => "index_photos_on_file_name", :unique => true
  add_index "photos", ["user_id"], :name => "index_photos_on_user_id"

  create_table "tags", :force => true do |t|
    t.string   "name"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password"
    t.string   "salt"
    t.boolean  "admin"
  end

  add_index "users", ["email"], :name => "index_users_on_email", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name", :unique => true

end
