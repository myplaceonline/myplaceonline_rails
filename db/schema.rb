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

ActiveRecord::Schema.define(version: 20150111180406) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accomplishments", force: true do |t|
    t.string   "name"
    t.text     "accomplishment"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "accomplishments", ["identity_id"], name: "index_accomplishments_on_identity_id", using: :btree

  create_table "activities", force: true do |t|
    t.string   "name"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "activities", ["identity_id"], name: "index_activities_on_identity_id", using: :btree

  create_table "apartment_leases", force: true do |t|
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "apartment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "monthly_rent", precision: 10, scale: 2
    t.decimal  "moveout_fee",  precision: 10, scale: 2
    t.decimal  "deposit",      precision: 10, scale: 2
    t.date     "terminate_by"
  end

  add_index "apartment_leases", ["apartment_id"], name: "index_apartment_leases_on_apartment_id", using: :btree

  create_table "apartments", force: true do |t|
    t.integer  "location_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "landlord_id"
  end

  add_index "apartments", ["identity_id"], name: "index_apartments_on_identity_id", using: :btree
  add_index "apartments", ["landlord_id"], name: "index_apartments_on_landlord_id", using: :btree
  add_index "apartments", ["location_id"], name: "index_apartments_on_location_id", using: :btree

  create_table "banks", force: true do |t|
    t.integer  "identity_id"
    t.integer  "location_id"
    t.integer  "password_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "banks", ["identity_id"], name: "index_banks_on_identity_id", using: :btree
  add_index "banks", ["location_id"], name: "index_banks_on_location_id", using: :btree
  add_index "banks", ["password_id"], name: "index_banks_on_password_id", using: :btree

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

  create_table "contacts", force: true do |t|
    t.integer  "ref_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "contacts", ["identity_id"], name: "index_contacts_on_identity_id", using: :btree
  add_index "contacts", ["ref_id"], name: "index_contacts_on_ref_id", using: :btree

  create_table "conversations", force: true do |t|
    t.integer  "contact_id"
    t.text     "conversation"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "conversations", ["contact_id"], name: "index_conversations_on_contact_id", using: :btree

  create_table "credit_scores", force: true do |t|
    t.date     "score_date"
    t.integer  "score"
    t.string   "source"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_scores", ["identity_id"], name: "index_credit_scores_on_identity_id", using: :btree

  create_table "encrypted_values", force: true do |t|
    t.binary   "val"
    t.binary   "salt"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "encryption_type"
  end

  add_index "encrypted_values", ["user_id"], name: "index_encrypted_values_on_user_id", using: :btree

  create_table "feeds", force: true do |t|
    t.string   "name"
    t.string   "url"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "feeds", ["identity_id"], name: "index_feeds_on_identity_id", using: :btree

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
    t.string   "name"
    t.date     "birthday"
    t.text     "notes"
  end

  add_index "identities", ["owner_id"], name: "index_identities_on_owner_id", using: :btree

  create_table "identity_emails", force: true do |t|
    t.string   "email"
    t.integer  "ref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identity_emails", ["ref_id"], name: "index_identity_emails_on_ref_id", using: :btree

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

  create_table "identity_phones", force: true do |t|
    t.string   "number"
    t.integer  "ref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identity_phones", ["ref_id"], name: "index_identity_phones_on_ref_id", using: :btree

  create_table "jokes", force: true do |t|
    t.string   "name"
    t.text     "joke"
    t.string   "source"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "jokes", ["identity_id"], name: "index_jokes_on_identity_id", using: :btree

  create_table "location_phones", force: true do |t|
    t.string   "number"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "location_phones", ["location_id"], name: "index_location_phones_on_location_id", using: :btree

  create_table "locations", force: true do |t|
    t.string   "name"
    t.string   "address1"
    t.string   "address2"
    t.string   "address3"
    t.string   "region"
    t.string   "sub_region1"
    t.string   "sub_region2"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "postal_code"
  end

  add_index "locations", ["identity_id"], name: "index_locations_on_identity_id", using: :btree

  create_table "movies", force: true do |t|
    t.string   "name"
    t.datetime "watched"
    t.string   "url"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["identity_id"], name: "index_movies_on_identity_id", using: :btree

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
    t.datetime "defunct"
    t.string   "email"
  end

  add_index "passwords", ["identity_id"], name: "index_passwords_on_identity_id", using: :btree
  add_index "passwords", ["password_encrypted_id"], name: "index_passwords_on_password_encrypted_id", using: :btree

  create_table "promises", force: true do |t|
    t.string   "name"
    t.date     "due"
    t.text     "promise"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "promises", ["identity_id"], name: "index_promises_on_identity_id", using: :btree

  create_table "subscriptions", force: true do |t|
    t.string   "name"
    t.date     "start_date"
    t.date     "end_date"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text     "notes"
  end

  add_index "subscriptions", ["identity_id"], name: "index_subscriptions_on_identity_id", using: :btree

  create_table "to_dos", force: true do |t|
    t.string   "short_description"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "to_dos", ["identity_id"], name: "index_to_dos_on_identity_id", using: :btree

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
    t.string   "timezone"
  end

  add_index "users", ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
  add_index "users", ["email"], name: "index_users_on_email", unique: true, using: :btree
  add_index "users", ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
  add_index "users", ["unlock_token"], name: "index_users_on_unlock_token", unique: true, using: :btree

  create_table "wisdoms", force: true do |t|
    t.string   "name"
    t.text     "wisdom"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wisdoms", ["identity_id"], name: "index_wisdoms_on_identity_id", using: :btree

end
