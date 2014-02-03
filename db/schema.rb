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
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130328175626) do

  create_table "event_statuses", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "events", :force => true do |t|
    t.integer  "parameter_id"
    t.integer  "subject_id"
    t.integer  "event_status_id"
    t.text     "name"
    t.string   "short_name"
    t.datetime "date_time"
    t.datetime "created_at",      :null => false
    t.datetime "updated_at",      :null => false
  end

  create_table "formulas", :force => true do |t|
    t.text     "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "groups", :force => true do |t|
    t.text     "name"
    t.string   "short_name"
    t.integer  "position"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_deleted", :default => false
  end

  create_table "param_levels", :force => true do |t|
    t.integer  "parameter_id"
    t.integer  "subject_id"
    t.float    "down_level"
    t.float    "up_level"
    t.string   "color"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "param_presets", :force => true do |t|
    t.integer  "parameter_id"
    t.integer  "subject_id"
    t.datetime "date_time"
    t.float    "down_preset"
    t.float    "up_preset"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "param_refs", :force => true do |t|
    t.integer  "parameter_id"
    t.integer  "child_parameter_id"
    t.integer  "position"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "param_subjects", :force => true do |t|
    t.integer  "parameter_id"
    t.integer  "subject_id"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "param_vals", :force => true do |t|
    t.integer  "parameter_id"
    t.integer  "subject_id"
    t.datetime "date_time"
    t.float    "val_numeric"
    t.float    "val_string"
    t.datetime "created_at",   :null => false
    t.datetime "updated_at",   :null => false
  end

  create_table "parameters", :force => true do |t|
    t.integer  "group_id"
    t.integer  "formula_id"
    t.integer  "uom_id"
    t.text     "name"
    t.string   "short_name"
    t.integer  "position"
    t.datetime "created_at",                    :null => false
    t.datetime "updated_at",                    :null => false
    t.boolean  "is_deleted", :default => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  create_table "roles", :force => true do |t|
    t.string   "name",       :default => "", :null => false
    t.datetime "created_at",                 :null => false
    t.datetime "updated_at",                 :null => false
  end

  add_index "roles", ["name"], :name => "index_roles_on_name"

  create_table "subjects", :force => true do |t|
    t.integer  "country_id"
    t.integer  "district_id"
    t.text     "name"
    t.string   "short_name"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "uoms", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "users", :force => true do |t|
    t.string   "login",               :default => "", :null => false
    t.string   "name",                :default => "", :null => false
    t.string   "email",               :default => "", :null => false
    t.string   "encrypted_password",  :default => "", :null => false
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",       :default => 0
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.string   "current_sign_in_ip"
    t.string   "last_sign_in_ip"
    t.datetime "locked_at"
    t.integer  "role_id",             :default => 0,  :null => false
    t.datetime "created_at",                          :null => false
    t.datetime "updated_at",                          :null => false
  end

  add_index "users", ["email"], :name => "index_users_on_email"
  add_index "users", ["login"], :name => "index_users_on_login", :unique => true
  add_index "users", ["name"], :name => "index_users_on_name"
  add_index "users", ["role_id"], :name => "index_users_on_role_id"

end
