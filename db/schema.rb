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

ActiveRecord::Schema.define(version: 20141226063623) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "position"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "categories", ["name"], name: "index_categories_on_name", unique: true, using: :btree
  add_index "categories", ["parent_id"], name: "index_categories_on_parent_id", using: :btree

  create_table "category_points_amounts", force: true do |t|
    t.integer  "identity_id"
    t.integer  "category_id"
    t.integer  "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "visits"
    t.datetime "last_visit"
  end

  add_index "category_points_amounts", ["category_id"], name: "index_category_points_amounts_on_category_id", using: :btree
  add_index "category_points_amounts", ["identity_id"], name: "index_category_points_amounts_on_identity_id", using: :btree

  create_table "encrypted_values", force: true do |t|
    t.binary   "val"
    t.binary   "salt"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "encryption_type"
  end

  add_index "encrypted_values", ["user_id"], name: "index_encrypted_values_on_user_id", using: :btree

  create_table "files", force: true do |t|
    t.integer "identity_file_id"
    t.string  "style"
    t.binary  "file_contents"
  end

  create_table "identities", force: true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points"
  end

  add_index "identities", ["owner_id"], name: "index_identities_on_owner_id", using: :btree

  create_table "identity_files", force: true do |t|
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.integer  "encrypted_password_id"
  end

  add_index "identity_files", ["encrypted_password_id"], name: "index_identity_files_on_encrypted_password_id", using: :btree
  add_index "identity_files", ["identity_id"], name: "index_identity_files_on_identity_id", using: :btree

  create_table "password_secrets", force: true do |t|
    t.string   "question"
    t.string   "answer"
    t.integer  "answer_encrypted_id"
    t.integer  "password_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "password_secrets", ["answer_encrypted_id"], name: "index_password_secrets_on_answer_encrypted_id", using: :btree
  add_index "password_secrets", ["password_id"], name: "index_password_secrets_on_password_id", using: :btree

  create_table "passwords", force: true do |t|
    t.string   "name"
    t.string   "user"
    t.string   "password"
    t.string   "url"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "password_encrypted_id"
    t.string   "account_number"
  end

  add_index "passwords", ["identity_id"], name: "index_passwords_on_identity_id", using: :btree
  add_index "passwords", ["password_encrypted_id"], name: "index_passwords_on_password_encrypted_id", using: :btree

  create_table "users", force: true do |t|
    t.string   "email",                  default: "",    null: false
    t.string   "encrypted_password",     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "primary_identity_id"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer  "failed_attempts",        default: 0
    t.string   "unlock_token"
    t.datetime "locked_at"
    t.string   "unconfirmed_email"
    t.boolean  "encrypt_by_default",     default: false
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

end
