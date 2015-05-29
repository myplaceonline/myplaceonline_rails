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

ActiveRecord::Schema.define(version: 20150529220107) do

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

  create_table "acne_measurements", force: true do |t|
    t.datetime "measurement_datetime"
    t.string   "acne_location"
    t.integer  "total_pimples"
    t.integer  "new_pimples"
    t.integer  "worrying_pimples"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "acne_measurements", ["identity_id"], name: "index_acne_measurements_on_identity_id", using: :btree

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
    t.integer  "identity_id"
  end

  add_index "apartment_leases", ["apartment_id"], name: "index_apartment_leases_on_apartment_id", using: :btree
  add_index "apartment_leases", ["identity_id"], name: "index_apartment_leases_on_identity_id", using: :btree

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

  create_table "blood_concentrations", force: true do |t|
    t.string   "concentration_name"
    t.integer  "concentration_type"
    t.decimal  "concentration_minimum", precision: 10, scale: 2
    t.decimal  "concentration_maximum", precision: 10, scale: 2
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blood_concentrations", ["identity_id"], name: "index_blood_concentrations_on_identity_id", using: :btree

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

  create_table "blood_test_results", force: true do |t|
    t.integer  "blood_test_id"
    t.integer  "blood_concentration_id"
    t.decimal  "concentration",          precision: 10, scale: 2
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blood_test_results", ["blood_concentration_id"], name: "index_blood_test_results_on_blood_concentration_id", using: :btree
  add_index "blood_test_results", ["blood_test_id"], name: "index_blood_test_results_on_blood_test_id", using: :btree
  add_index "blood_test_results", ["identity_id"], name: "index_blood_test_results_on_identity_id", using: :btree

  create_table "blood_tests", force: true do |t|
    t.datetime "fast_started"
    t.datetime "test_time"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "blood_tests", ["identity_id"], name: "index_blood_tests_on_identity_id", using: :btree

  create_table "calculation_elements", force: true do |t|
    t.integer  "left_operand_id"
    t.integer  "right_operand_id"
    t.integer  "operator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identity_id"
  end

  add_index "calculation_elements", ["identity_id"], name: "index_calculation_elements_on_identity_id", using: :btree
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
    t.integer  "identity_id"
  end

  add_index "calculation_inputs", ["calculation_form_id"], name: "index_calculation_inputs_on_calculation_form_id", using: :btree
  add_index "calculation_inputs", ["identity_id"], name: "index_calculation_inputs_on_identity_id", using: :btree

  create_table "calculation_operands", force: true do |t|
    t.string   "constant_value"
    t.integer  "calculation_element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "calculation_input_id"
    t.integer  "identity_id"
  end

  add_index "calculation_operands", ["calculation_element_id"], name: "index_calculation_operands_on_calculation_element_id", using: :btree
  add_index "calculation_operands", ["identity_id"], name: "index_calculation_operands_on_identity_id", using: :btree

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

  create_table "cashbacks", force: true do |t|
    t.integer  "identity_id"
    t.decimal  "cashback_percentage", precision: 10, scale: 2
    t.string   "applies_to"
    t.date     "start_date"
    t.date     "end_date"
    t.decimal  "yearly_maximum",      precision: 10, scale: 2
    t.text     "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "default_cashback"
  end

  add_index "cashbacks", ["identity_id"], name: "index_cashbacks_on_identity_id", using: :btree

  create_table "categories", force: true do |t|
    t.string   "name"
    t.string   "link"
    t.integer  "position"
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "additional_filtertext"
    t.string   "icon"
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

  create_table "checklist_items", force: true do |t|
    t.string   "checklist_item_name"
    t.integer  "checklist_id"
    t.integer  "position"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklist_items", ["checklist_id"], name: "index_checklist_items_on_checklist_id", using: :btree
  add_index "checklist_items", ["identity_id"], name: "index_checklist_items_on_identity_id", using: :btree

  create_table "checklists", force: true do |t|
    t.string   "checklist_name"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklists", ["identity_id"], name: "index_checklists_on_identity_id", using: :btree

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
    t.integer  "identity_id"
  end

  add_index "conversations", ["contact_id"], name: "index_conversations_on_contact_id", using: :btree
  add_index "conversations", ["identity_id"], name: "index_conversations_on_identity_id", using: :btree

  create_table "credit_card_cashbacks", force: true do |t|
    t.integer  "identity_id"
    t.integer  "credit_card_id"
    t.integer  "cashback_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "credit_card_cashbacks", ["cashback_id"], name: "index_credit_card_cashbacks_on_cashback_id", using: :btree
  add_index "credit_card_cashbacks", ["credit_card_id"], name: "index_credit_card_cashbacks_on_credit_card_id", using: :btree
  add_index "credit_card_cashbacks", ["identity_id"], name: "index_credit_card_cashbacks_on_identity_id", using: :btree

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
    t.integer  "card_type"
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

  create_table "drinks", force: true do |t|
    t.integer  "identity_id"
    t.string   "drink_name"
    t.text     "notes"
    t.decimal  "calories",    precision: 10, scale: 2
    t.decimal  "price",       precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "drinks", ["identity_id"], name: "index_drinks_on_identity_id", using: :btree

  create_table "encrypted_values", force: true do |t|
    t.string   "val"
    t.binary   "salt"
    t.integer  "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "encryption_type"
  end

  add_index "encrypted_values", ["user_id"], name: "index_encrypted_values_on_user_id", using: :btree

  create_table "exercises", force: true do |t|
    t.datetime "exercise_start"
    t.datetime "exercise_end"
    t.string   "exercise_activity"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "situps"
    t.integer  "pushups"
  end

  add_index "exercises", ["identity_id"], name: "index_exercises_on_identity_id", using: :btree

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

  create_table "food_ingredients", force: true do |t|
    t.integer  "identity_id"
    t.integer  "parent_food_id"
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "food_ingredients", ["food_id"], name: "index_food_ingredients_on_food_id", using: :btree
  add_index "food_ingredients", ["identity_id"], name: "index_food_ingredients_on_identity_id", using: :btree
  add_index "food_ingredients", ["parent_food_id"], name: "index_food_ingredients_on_parent_food_id", using: :btree

  create_table "foods", force: true do |t|
    t.integer  "identity_id"
    t.string   "food_name"
    t.text     "notes"
    t.decimal  "calories",    precision: 10, scale: 2
    t.decimal  "price",       precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "weight_type"
    t.decimal  "weight",      precision: 10, scale: 2
  end

  add_index "foods", ["identity_id"], name: "index_foods_on_identity_id", using: :btree

  create_table "heart_rates", force: true do |t|
    t.integer  "beats"
    t.date     "measurement_date"
    t.string   "measurement_source"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "heart_rates", ["identity_id"], name: "index_heart_rates_on_identity_id", using: :btree

  create_table "heights", force: true do |t|
    t.decimal  "height_amount",      precision: 10, scale: 2
    t.integer  "amount_type"
    t.date     "measurement_date"
    t.string   "measurement_source"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "heights", ["identity_id"], name: "index_heights_on_identity_id", using: :btree

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
    t.integer  "identity_id"
  end

  add_index "identity_emails", ["identity_id"], name: "index_identity_emails_on_identity_id", using: :btree
  add_index "identity_emails", ["ref_id"], name: "index_identity_emails_on_ref_id", using: :btree

  create_table "identity_file_folders", force: true do |t|
    t.string   "folder_name"
    t.integer  "parent_folder_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "identity_file_folders", ["identity_id"], name: "index_identity_file_folders_on_identity_id", using: :btree
  add_index "identity_file_folders", ["parent_folder_id"], name: "index_identity_file_folders_on_parent_folder_id", using: :btree

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
    t.integer  "folder_id"
  end

  add_index "identity_files", ["encrypted_password_id"], name: "index_identity_files_on_encrypted_password_id", using: :btree
  add_index "identity_files", ["folder_id"], name: "index_identity_files_on_folder_id", using: :btree
  add_index "identity_files", ["identity_id"], name: "index_identity_files_on_identity_id", using: :btree

  create_table "identity_locations", force: true do |t|
    t.integer  "location_id"
    t.integer  "ref_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identity_id"
  end

  add_index "identity_locations", ["identity_id"], name: "index_identity_locations_on_identity_id", using: :btree
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

  create_table "life_goals", force: true do |t|
    t.string   "life_goal_name"
    t.text     "notes"
    t.integer  "position"
    t.datetime "goal_started"
    t.datetime "goal_ended"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "life_goals", ["identity_id"], name: "index_life_goals_on_identity_id", using: :btree

  create_table "list_items", force: true do |t|
    t.string   "name"
    t.integer  "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identity_id"
  end

  add_index "list_items", ["identity_id"], name: "index_list_items_on_identity_id", using: :btree
  add_index "list_items", ["list_id"], name: "index_list_items_on_list_id", using: :btree

  create_table "lists", force: true do |t|
    t.string   "name"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "lists", ["identity_id"], name: "index_lists_on_identity_id", using: :btree

  create_table "loans", force: true do |t|
    t.string   "lender"
    t.decimal  "amount",          precision: 10, scale: 2
    t.date     "start"
    t.date     "paid_off"
    t.decimal  "monthly_payment", precision: 10, scale: 2
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "loans", ["identity_id"], name: "index_loans_on_identity_id", using: :btree

  create_table "location_phones", force: true do |t|
    t.string   "number"
    t.integer  "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identity_id"
  end

  add_index "location_phones", ["identity_id"], name: "index_location_phones_on_identity_id", using: :btree
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
    t.text     "notes"
  end

  add_index "locations", ["identity_id"], name: "index_locations_on_identity_id", using: :btree

  create_table "meal_drinks", force: true do |t|
    t.integer  "identity_id"
    t.integer  "meal_id"
    t.integer  "drink_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meal_drinks", ["drink_id"], name: "index_meal_drinks_on_drink_id", using: :btree
  add_index "meal_drinks", ["identity_id"], name: "index_meal_drinks_on_identity_id", using: :btree
  add_index "meal_drinks", ["meal_id"], name: "index_meal_drinks_on_meal_id", using: :btree

  create_table "meal_foods", force: true do |t|
    t.integer  "identity_id"
    t.integer  "meal_id"
    t.integer  "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "food_servings", precision: 10, scale: 2
  end

  add_index "meal_foods", ["food_id"], name: "index_meal_foods_on_food_id", using: :btree
  add_index "meal_foods", ["identity_id"], name: "index_meal_foods_on_identity_id", using: :btree
  add_index "meal_foods", ["meal_id"], name: "index_meal_foods_on_meal_id", using: :btree

  create_table "meal_vitamins", force: true do |t|
    t.integer  "identity_id"
    t.integer  "meal_id"
    t.integer  "vitamin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meal_vitamins", ["identity_id"], name: "index_meal_vitamins_on_identity_id", using: :btree
  add_index "meal_vitamins", ["meal_id"], name: "index_meal_vitamins_on_meal_id", using: :btree
  add_index "meal_vitamins", ["vitamin_id"], name: "index_meal_vitamins_on_vitamin_id", using: :btree

  create_table "meals", force: true do |t|
    t.datetime "meal_time"
    t.text     "notes"
    t.integer  "location_id"
    t.decimal  "price",       precision: 10, scale: 2
    t.decimal  "calories",    precision: 10, scale: 2
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "meals", ["identity_id"], name: "index_meals_on_identity_id", using: :btree
  add_index "meals", ["location_id"], name: "index_meals_on_location_id", using: :btree

  create_table "medical_condition_instances", force: true do |t|
    t.datetime "condition_start"
    t.datetime "condition_end"
    t.text     "notes"
    t.integer  "medical_condition_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medical_condition_instances", ["identity_id"], name: "index_medical_condition_instances_on_identity_id", using: :btree
  add_index "medical_condition_instances", ["medical_condition_id"], name: "index_medical_condition_instances_on_medical_condition_id", using: :btree

  create_table "medical_conditions", force: true do |t|
    t.string   "medical_condition_name"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medical_conditions", ["identity_id"], name: "index_medical_conditions_on_identity_id", using: :btree

  create_table "medicine_usage_medicines", force: true do |t|
    t.integer  "identity_id"
    t.integer  "medicine_usage_id"
    t.integer  "medicine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medicine_usage_medicines", ["identity_id"], name: "index_medicine_usage_medicines_on_identity_id", using: :btree
  add_index "medicine_usage_medicines", ["medicine_id"], name: "index_medicine_usage_medicines_on_medicine_id", using: :btree
  add_index "medicine_usage_medicines", ["medicine_usage_id"], name: "index_medicine_usage_medicines_on_medicine_usage_id", using: :btree

  create_table "medicine_usages", force: true do |t|
    t.datetime "usage_time"
    t.integer  "medicine_id"
    t.text     "usage_notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medicine_usages", ["identity_id"], name: "index_medicine_usages_on_identity_id", using: :btree
  add_index "medicine_usages", ["medicine_id"], name: "index_medicine_usages_on_medicine_id", using: :btree

  create_table "medicines", force: true do |t|
    t.string   "medicine_name"
    t.decimal  "dosage",        precision: 10, scale: 2
    t.integer  "dosage_type"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "medicines", ["identity_id"], name: "index_medicines_on_identity_id", using: :btree

  create_table "movies", force: true do |t|
    t.string   "name"
    t.datetime "watched"
    t.string   "url"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "movies", ["identity_id"], name: "index_movies_on_identity_id", using: :btree

  create_table "pains", force: true do |t|
    t.string   "pain_location"
    t.integer  "intensity"
    t.datetime "pain_start_time"
    t.datetime "pain_end_time"
    t.text     "notes"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pains", ["identity_id"], name: "index_pains_on_identity_id", using: :btree

  create_table "password_secrets", force: true do |t|
    t.string   "question"
    t.string   "answer"
    t.integer  "answer_encrypted_id"
    t.integer  "password_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "identity_id"
  end

  add_index "password_secrets", ["answer_encrypted_id"], name: "index_password_secrets_on_answer_encrypted_id", using: :btree
  add_index "password_secrets", ["identity_id"], name: "index_password_secrets_on_identity_id", using: :btree
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

  create_table "recreational_vehicle_loans", force: true do |t|
    t.integer  "recreational_vehicle_id"
    t.integer  "loan_id"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recreational_vehicle_loans", ["identity_id"], name: "index_recreational_vehicle_loans_on_identity_id", using: :btree
  add_index "recreational_vehicle_loans", ["loan_id"], name: "index_recreational_vehicle_loans_on_loan_id", using: :btree
  add_index "recreational_vehicle_loans", ["recreational_vehicle_id"], name: "index_recreational_vehicle_loans_on_recreational_vehicle_id", using: :btree

  create_table "recreational_vehicles", force: true do |t|
    t.string   "rv_name"
    t.string   "vin"
    t.string   "manufacturer"
    t.string   "model"
    t.integer  "year"
    t.decimal  "price",                 precision: 10, scale: 2
    t.decimal  "msrp",                  precision: 10, scale: 2
    t.date     "purchased"
    t.date     "owned_start"
    t.date     "owned_end"
    t.text     "notes"
    t.integer  "location_purchased_id"
    t.integer  "vehicle_id"
    t.decimal  "wet_weight",            precision: 10, scale: 2
    t.integer  "sleeps"
    t.integer  "dimensions_type"
    t.decimal  "exterior_length",       precision: 10, scale: 2
    t.decimal  "exterior_width",        precision: 10, scale: 2
    t.decimal  "exterior_height",       precision: 10, scale: 2
    t.decimal  "exterior_height_over",  precision: 10, scale: 2
    t.decimal  "interior_height",       precision: 10, scale: 2
    t.integer  "liquid_capacity_type"
    t.integer  "fresh_tank"
    t.integer  "grey_tank"
    t.integer  "black_tank"
    t.date     "warranty_ends"
    t.integer  "water_heater"
    t.integer  "propane"
    t.integer  "volume_type"
    t.integer  "weight_type"
    t.integer  "refrigerator"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "recreational_vehicles", ["identity_id"], name: "index_recreational_vehicles_on_identity_id", using: :btree
  add_index "recreational_vehicles", ["location_purchased_id"], name: "index_recreational_vehicles_on_location_purchased_id", using: :btree
  add_index "recreational_vehicles", ["vehicle_id"], name: "index_recreational_vehicles_on_vehicle_id", using: :btree

  create_table "sleep_measurements", force: true do |t|
    t.datetime "sleep_start_time"
    t.datetime "sleep_end_time"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sleep_measurements", ["identity_id"], name: "index_sleep_measurements_on_identity_id", using: :btree

  create_table "songs", force: true do |t|
    t.string   "song_name"
    t.decimal  "song_rating", precision: 10, scale: 2
    t.text     "lyrics"
    t.integer  "song_plays"
    t.datetime "lastplay"
    t.boolean  "secret"
    t.boolean  "awesome"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "songs", ["identity_id"], name: "index_songs_on_identity_id", using: :btree

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

  create_table "sun_exposures", force: true do |t|
    t.datetime "exposure_start"
    t.datetime "exposure_end"
    t.string   "uncovered_body_parts"
    t.string   "sunscreened_body_parts"
    t.string   "sunscreen_type"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sun_exposures", ["identity_id"], name: "index_sun_exposures_on_identity_id", using: :btree

  create_table "temperatures", force: true do |t|
    t.datetime "measured"
    t.decimal  "measured_temperature", precision: 10, scale: 2
    t.string   "measurement_source"
    t.integer  "temperature_type"
    t.integer  "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "temperatures", ["identity_id"], name: "index_temperatures_on_identity_id", using: :btree

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
    t.integer  "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer  "loan_id"
    t.integer  "identity_id"
  end

  add_index "vehicle_loans", ["identity_id"], name: "index_vehicle_loans_on_identity_id", using: :btree
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
    t.integer  "identity_id"
  end

  add_index "vehicle_services", ["identity_id"], name: "index_vehicle_services_on_identity_id", using: :btree
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
    t.string   "trim_name"
    t.integer  "dimensions_type"
    t.decimal  "height",                   precision: 10, scale: 2
    t.decimal  "width",                    precision: 10, scale: 2
    t.decimal  "length",                   precision: 10, scale: 2
    t.decimal  "wheel_base",               precision: 10, scale: 2
    t.decimal  "ground_clearance",         precision: 10, scale: 2
    t.integer  "weight_type"
    t.integer  "doors_type"
    t.integer  "passenger_seats"
    t.decimal  "gvwr",                     precision: 10, scale: 2
    t.decimal  "gcwr",                     precision: 10, scale: 2
    t.decimal  "gawr_front",               precision: 10, scale: 2
    t.decimal  "gawr_rear",                precision: 10, scale: 2
    t.string   "front_axle_details"
    t.decimal  "front_axle_rating",        precision: 10, scale: 2
    t.string   "front_suspension_details"
    t.decimal  "front_suspension_rating",  precision: 10, scale: 2
    t.string   "rear_axle_details"
    t.decimal  "rear_axle_rating",         precision: 10, scale: 2
    t.string   "rear_suspension_details"
    t.decimal  "rear_suspension_rating",   precision: 10, scale: 2
    t.string   "tire_details"
    t.decimal  "tire_rating",              precision: 10, scale: 2
    t.decimal  "tire_diameter",            precision: 10, scale: 2
    t.string   "wheel_details"
    t.decimal  "wheel_rating",             precision: 10, scale: 2
    t.integer  "engine_type"
    t.integer  "wheel_drive_type"
    t.integer  "wheels_type"
    t.integer  "fuel_tank_capacity_type"
    t.decimal  "fuel_tank_capacity",       precision: 10, scale: 2
    t.decimal  "wet_weight_front",         precision: 10, scale: 2
    t.decimal  "wet_weight_rear",          precision: 10, scale: 2
    t.decimal  "tailgate_weight",          precision: 10, scale: 2
    t.integer  "horsepower"
    t.integer  "cylinders"
    t.integer  "displacement_type"
    t.integer  "doors"
    t.decimal  "displacement",             precision: 10, scale: 2
    t.decimal  "bed_length",               precision: 10, scale: 2
    t.integer  "recreational_vehicle_id"
    t.decimal  "price",                    precision: 10, scale: 2
    t.decimal  "msrp",                     precision: 10, scale: 2
  end

  add_index "vehicles", ["identity_id"], name: "index_vehicles_on_identity_id", using: :btree

  create_table "vitamin_ingredients", force: true do |t|
    t.integer  "identity_id"
    t.integer  "parent_vitamin_id"
    t.integer  "vitamin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vitamin_ingredients", ["identity_id"], name: "index_vitamin_ingredients_on_identity_id", using: :btree
  add_index "vitamin_ingredients", ["parent_vitamin_id"], name: "index_vitamin_ingredients_on_parent_vitamin_id", using: :btree
  add_index "vitamin_ingredients", ["vitamin_id"], name: "index_vitamin_ingredients_on_vitamin_id", using: :btree

  create_table "vitamins", force: true do |t|
    t.integer  "identity_id"
    t.string   "vitamin_name"
    t.text     "notes"
    t.decimal  "vitamin_amount", precision: 10, scale: 2
    t.integer  "amount_type"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "vitamins", ["identity_id"], name: "index_vitamins_on_identity_id", using: :btree

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
