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

ActiveRecord::Schema.define(version: 20150419173653) do

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
    t.text     "notes"
  end

  add_index "apartments", ["identity_id"], name: "index_apartments_on_identity_id", using: :btree
  add_index "apartments", ["landlord_id"], name: "index_apartments_on_landlord_id", using: :btree
  add_index "apartments", ["location_id"], name: "index_apartments_on_location_id", using: :btree

  create_table "bank_accounts", force: true do |t|
    t.string   "name"
    t.string   "account_number"
    t.integer  "account_number_encrypted_id"
    t.string   "routing_number"
    t.integer  "routing_number_encrypted_id"
    t.string   "pin"
    t.integer  "pin_encrypted_id"
    t.integer  "password_id"
    t.integer  "company_id"
    t.integer  "home_address_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "bank_accounts", ["account_number_encrypted_id"], name: "index_bank_accounts_on_account_number_encrypted_id", using: :btree
  add_index "bank_accounts", ["company_id"], name: "index_bank_accounts_on_company_id", using: :btree
  add_index "bank_accounts", ["home_address_id"], name: "index_bank_accounts_on_home_address_id", using: :btree
  add_index "bank_accounts", ["identity_id"], name: "index_bank_accounts_on_identity_id", using: :btree
  add_index "bank_accounts", ["password_id"], name: "index_bank_accounts_on_password_id", using: :btree
  add_index "bank_accounts", ["pin_encrypted_id"], name: "index_bank_accounts_on_pin_encrypted_id", using: :btree
  add_index "bank_accounts", ["routing_number_encrypted_id"], name: "index_bank_accounts_on_routing_number_encrypted_id", using: :btree

  create_table "blood_pressures", force: true do |t|
    t.integer  "systolic_pressure"
    t.integer  "diastolic_pressure"
    t.date     "measurement_date"
    t.string   "measurement_source"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blood_pressures", ["identity_id"], name: "index_blood_pressures_on_identity_id", using: :btree

  create_table "calculation_elements", force: true do |t|
    t.integer  "left_operand_id"
    t.integer  "right_operand_id"
    t.integer  "operator"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "calculation_elements", ["left_operand_id"], name: "index_calculation_elements_on_left_operand_id", using: :btree
  add_index "calculation_elements", ["right_operand_id"], name: "index_calculation_elements_on_right_operand_id", using: :btree

  create_table "calculation_forms", force: true do |t|
    t.string   "name"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "root_element_id"
    t.text     "equation"
    t.boolean  "is_duplicate"
  end

  add_index "calculation_forms", ["identity_id"], name: "index_calculation_forms_on_identity_id", using: :btree
  add_index "calculation_forms", ["root_element_id"], name: "index_calculation_forms_on_root_element_id", using: :btree

  create_table "calculation_inputs", force: true do |t|
    t.string   "input_name"
    t.string   "input_value"
    t.integer  "calculation_form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "variable_name"
  end

  add_index "calculation_inputs", ["calculation_form_id"], name: "index_calculation_inputs_on_calculation_form_id", using: :btree

  create_table "calculation_operands", force: true do |t|
    t.string   "constant_value"
    t.integer  "calculation_element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calculation_input_id"
  end

  add_index "calculation_operands", ["calculation_element_id"], name: "index_calculation_operands_on_calculation_element_id", using: :btree

  create_table "calculations", force: true do |t|
    t.string   "name"
    t.integer  "calculation_form_id"
    t.decimal  "result",                       precision: 10, scale: 2
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "original_calculation_form_id"
  end

  add_index "calculations", ["calculation_form_id"], name: "index_calculations_on_calculation_form_id", using: :btree
  add_index "calculations", ["identity_id"], name: "index_calculations_on_identity_id", using: :btree

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

  create_table "companies", force: true do |t|
    t.integer  "identity_id"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "name"
  end

  add_index "companies", ["identity_id"], name: "index_companies_on_identity_id", using: :btree
  add_index "companies", ["location_id"], name: "index_companies_on_location_id", using: :btree

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
    t.date     "when"
  end

  add_index "conversations", ["contact_id"], name: "index_conversations_on_contact_id", using: :btree

  create_table "credit_cards", force: true do |t|
    t.string   "name"
    t.string   "number"
    t.date     "expires"
    t.string   "security_code"
    t.integer  "password_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "pin"
    t.text     "notes"
    t.integer  "address_id"
    t.integer  "number_encrypted_id"
    t.integer  "security_code_encrypted_id"
    t.integer  "pin_encrypted_id"
    t.integer  "expires_encrypted_id"
    t.datetime "defunct"
  end

  add_index "credit_cards", ["address_id"], name: "index_credit_cards_on_address_id", using: :btree
  add_index "credit_cards", ["expires_encrypted_id"], name: "index_credit_cards_on_expires_encrypted_id", using: :btree
  add_index "credit_cards", ["identity_id"], name: "index_credit_cards_on_identity_id", using: :btree
  add_index "credit_cards", ["number_encrypted_id"], name: "index_credit_cards_on_number_encrypted_id", using: :btree
  add_index "credit_cards", ["password_id"], name: "index_credit_cards_on_password_id", using: :btree
  add_index "credit_cards", ["pin_encrypted_id"], name: "index_credit_cards_on_pin_encrypted_id", using: :btree
  add_index "credit_cards", ["security_code_encrypted_id"], name: "index_credit_cards_on_security_code_encrypted_id", using: :btree

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

  create_table "heart_rates", force: true do |t|
    t.integer  "beats"
    t.date     "measurement_date"
    t.string   "measurement_source"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "heart_rates", ["identity_id"], name: "index_heart_rates_on_identity_id", using: :btree

  create_table "hypotheses", force: true do |t|
    t.string   "name"
    t.text     "notes"
    t.integer  "question_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "position"
  end

  add_index "hypotheses", ["identity_id"], name: "index_hypotheses_on_identity_id", using: :btree
  add_index "hypotheses", ["question_id"], name: "index_hypotheses_on_question_id", using: :btree

  create_table "hypothesis_experiments", force: true do |t|
    t.string   "name"
    t.text     "notes"
    t.date     "started"
    t.date     "ended"
    t.integer  "hypothesis_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "hypothesis_experiments", ["hypothesis_id"], name: "index_hypothesis_experiments_on_hypothesis_id", using: :btree
  add_index "hypothesis_experiments", ["identity_id"], name: "index_hypothesis_experiments_on_identity_id", using: :btree

  create_table "ideas", force: true do |t|
    t.string   "name"
    t.text     "idea"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "ideas", ["identity_id"], name: "index_ideas_on_identity_id", using: :btree

  create_table "identities", force: true do |t|
    t.integer  "owner_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "points"
    t.string   "name"
    t.date     "birthday"
    t.text     "notes"
    t.text     "notepad"
  end

  add_index "identities", ["owner_id"], name: "index_identities_on_owner_id", using: :btree

  create_table "identity_drivers_licenses", force: true do |t|
    t.string   "identifier"
    t.string   "region"
    t.string   "sub_region1"
    t.date     "expires"
    t.integer  "ref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identity_file_id"
    t.integer  "identity_id"
  end

  add_index "identity_drivers_licenses", ["ref_id"], name: "index_identity_drivers_licenses_on_ref_id", using: :btree

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
    t.text     "notes"
  end

  add_index "identity_files", ["encrypted_password_id"], name: "index_identity_files_on_encrypted_password_id", using: :btree
  add_index "identity_files", ["identity_id"], name: "index_identity_files_on_identity_id", using: :btree

  create_table "identity_locations", force: true do |t|
    t.integer  "location_id"
    t.integer  "ref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identity_locations", ["location_id"], name: "index_identity_locations_on_location_id", using: :btree
  add_index "identity_locations", ["ref_id"], name: "index_identity_locations_on_ref_id", using: :btree

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

  create_table "list_items", force: true do |t|
    t.string   "name"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "list_items", ["list_id"], name: "index_list_items_on_list_id", using: :btree

  create_table "lists", force: true do |t|
    t.string   "name"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["identity_id"], name: "index_lists_on_identity_id", using: :btree

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

  create_table "questions", force: true do |t|
    t.string   "name"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "questions", ["identity_id"], name: "index_questions_on_identity_id", using: :btree

  create_table "recipes", force: true do |t|
    t.string   "name"
    t.text     "recipe"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recipes", ["identity_id"], name: "index_recipes_on_identity_id", using: :btree

  create_table "sleep_measurements", force: true do |t|
    t.datetime "sleep_start_time"
    t.datetime "sleep_end_time"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sleep_measurements", ["identity_id"], name: "index_sleep_measurements_on_identity_id", using: :btree

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

  create_table "vehicle_loans", force: true do |t|
    t.string   "lender"
    t.integer  "vehicle_id"
    t.decimal  "amount",          precision: 10, scale: 2
    t.date     "start"
    t.date     "paid_off"
    t.decimal  "monthly_payment", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicle_loans", ["vehicle_id"], name: "index_vehicle_loans_on_vehicle_id", using: :btree

  create_table "vehicle_services", force: true do |t|
    t.integer  "vehicle_id"
    t.text     "notes"
    t.string   "short_description"
    t.date     "date_due"
    t.date     "date_serviced"
    t.text     "service_location"
    t.decimal  "cost",              precision: 10, scale: 2
    t.integer  "miles"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicle_services", ["vehicle_id"], name: "index_vehicle_services_on_vehicle_id", using: :btree

  create_table "vehicles", force: true do |t|
    t.string   "name"
    t.text     "notes"
    t.date     "owned_start"
    t.date     "owned_end"
    t.string   "vin"
    t.string   "manufacturer"
    t.string   "model"
    t.integer  "year"
    t.string   "color"
    t.string   "license_plate"
    t.string   "region"
    t.string   "sub_region1"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vehicles", ["identity_id"], name: "index_vehicles_on_identity_id", using: :btree

  create_table "websites", force: true do |t|
    t.string   "title"
    t.string   "url"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "websites", ["identity_id"], name: "index_websites_on_identity_id", using: :btree

  create_table "weights", force: true do |t|
    t.decimal  "amount",       precision: 10, scale: 2
    t.integer  "amount_type"
    t.date     "measure_date"
    t.string   "source"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "weights", ["identity_id"], name: "index_weights_on_identity_id", using: :btree

  create_table "wisdoms", force: true do |t|
    t.string   "name"
    t.text     "wisdom"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wisdoms", ["identity_id"], name: "index_wisdoms_on_identity_id", using: :btree

end
