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

ActiveRecord::Schema.define(version: 20170817032957) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "accomplishments", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "accomplishment"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_accomplishments_on_identity_id"
  end

  create_table "acne_measurement_pictures", id: :serial, force: :cascade do |t|
    t.integer "acne_measurement_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["acne_measurement_id"], name: "index_acne_measurement_pictures_on_acne_measurement_id"
    t.index ["identity_file_id"], name: "index_acne_measurement_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_acne_measurement_pictures_on_identity_id"
  end

  create_table "acne_measurements", id: :serial, force: :cascade do |t|
    t.datetime "measurement_datetime"
    t.string "acne_location", limit: 255
    t.integer "total_pimples"
    t.integer "new_pimples"
    t.integer "worrying_pimples"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_acne_measurements_on_identity_id"
  end

  create_table "activities", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.text "notes"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_activities_on_identity_id"
  end

  create_table "admin_emails", id: :serial, force: :cascade do |t|
    t.integer "email_id"
    t.integer "identity_id"
    t.string "send_only_to"
    t.string "exclude_emails"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["email_id"], name: "index_admin_emails_on_email_id"
    t.index ["identity_id"], name: "index_admin_emails_on_identity_id"
  end

  create_table "admin_text_messages", id: :serial, force: :cascade do |t|
    t.integer "text_message_id"
    t.integer "identity_id"
    t.string "send_only_to"
    t.string "exclude_numbers"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_admin_text_messages_on_identity_id"
    t.index ["text_message_id"], name: "index_admin_text_messages_on_text_message_id"
  end

  create_table "alerts_displays", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "suppress_hotel"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_alerts_displays_on_identity_id"
  end

  create_table "annuities", id: :serial, force: :cascade do |t|
    t.string "annuity_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_annuities_on_identity_id"
  end

  create_table "apartment_lease_files", id: :serial, force: :cascade do |t|
    t.integer "apartment_lease_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["apartment_lease_id"], name: "index_apartment_lease_files_on_apartment_lease_id"
    t.index ["identity_file_id"], name: "index_apartment_lease_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_apartment_lease_files_on_identity_id"
  end

  create_table "apartment_leases", id: :serial, force: :cascade do |t|
    t.date "start_date"
    t.date "end_date"
    t.integer "apartment_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "monthly_rent", precision: 10, scale: 2
    t.decimal "moveout_fee", precision: 10, scale: 2
    t.decimal "deposit", precision: 10, scale: 2
    t.date "terminate_by"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["apartment_id"], name: "index_apartment_leases_on_apartment_id"
    t.index ["identity_id"], name: "index_apartment_leases_on_identity_id"
  end

  create_table "apartment_pictures", id: :serial, force: :cascade do |t|
    t.integer "apartment_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["apartment_id"], name: "index_apartment_pictures_on_apartment_id"
    t.index ["identity_file_id"], name: "index_apartment_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_apartment_pictures_on_identity_id"
  end

  create_table "apartment_trash_pickups", id: :serial, force: :cascade do |t|
    t.integer "trash_type"
    t.text "notes"
    t.integer "apartment_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "repeat_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["apartment_id"], name: "index_apartment_trash_pickups_on_apartment_id"
    t.index ["identity_id"], name: "index_apartment_trash_pickups_on_identity_id"
    t.index ["repeat_id"], name: "index_apartment_trash_pickups_on_repeat_id"
  end

  create_table "apartments", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "landlord_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_apartments_on_identity_id"
    t.index ["landlord_id"], name: "index_apartments_on_landlord_id"
    t.index ["location_id"], name: "index_apartments_on_location_id"
  end

  create_table "awesome_list_items", id: :serial, force: :cascade do |t|
    t.string "item_name"
    t.integer "awesome_list_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["awesome_list_id"], name: "index_awesome_list_items_on_awesome_list_id"
    t.index ["identity_id"], name: "index_awesome_list_items_on_identity_id"
  end

  create_table "awesome_lists", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_awesome_lists_on_identity_id"
    t.index ["location_id"], name: "index_awesome_lists_on_location_id"
  end

  create_table "bank_accounts", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "account_number", limit: 255
    t.integer "account_number_encrypted_id"
    t.string "routing_number", limit: 255
    t.integer "routing_number_encrypted_id"
    t.string "pin", limit: 255
    t.integer "pin_encrypted_id"
    t.integer "password_id"
    t.integer "company_id"
    t.integer "home_address_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "visit_count"
    t.integer "rating"
    t.index ["account_number_encrypted_id"], name: "index_bank_accounts_on_account_number_encrypted_id"
    t.index ["company_id"], name: "index_bank_accounts_on_company_id"
    t.index ["home_address_id"], name: "index_bank_accounts_on_home_address_id"
    t.index ["identity_id"], name: "index_bank_accounts_on_identity_id"
    t.index ["password_id"], name: "index_bank_accounts_on_password_id"
    t.index ["pin_encrypted_id"], name: "index_bank_accounts_on_pin_encrypted_id"
    t.index ["routing_number_encrypted_id"], name: "index_bank_accounts_on_routing_number_encrypted_id"
  end

  create_table "bar_pictures", id: :serial, force: :cascade do |t|
    t.integer "bar_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["bar_id"], name: "index_bar_pictures_on_bar_id"
    t.index ["identity_file_id"], name: "index_bar_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_bar_pictures_on_identity_id"
  end

  create_table "bars", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "rating"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.index ["identity_id"], name: "index_bars_on_identity_id"
    t.index ["location_id"], name: "index_bars_on_location_id"
  end

  create_table "beaches", force: :cascade do |t|
    t.bigint "location_id"
    t.boolean "crowded"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_beaches_on_identity_id"
    t.index ["location_id"], name: "index_beaches_on_location_id"
  end

  create_table "bet_contacts", id: :serial, force: :cascade do |t|
    t.integer "bet_id"
    t.integer "identity_id"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["bet_id"], name: "index_bet_contacts_on_bet_id"
    t.index ["contact_id"], name: "index_bet_contacts_on_contact_id"
    t.index ["identity_id"], name: "index_bet_contacts_on_identity_id"
  end

  create_table "bets", id: :serial, force: :cascade do |t|
    t.string "bet_name"
    t.date "bet_start_date"
    t.date "bet_end_date"
    t.decimal "bet_amount", precision: 10, scale: 2
    t.decimal "odds_ratio", precision: 10, scale: 2
    t.boolean "odds_direction_owner"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.string "bet_currency"
    t.integer "bet_status"
    t.index ["identity_id"], name: "index_bets_on_identity_id"
  end

  create_table "bill_files", id: :serial, force: :cascade do |t|
    t.integer "bill_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bill_id"], name: "index_bill_files_on_bill_id"
    t.index ["identity_file_id"], name: "index_bill_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_bill_files_on_identity_id"
  end

  create_table "bills", id: :serial, force: :cascade do |t|
    t.string "bill_name"
    t.date "bill_date"
    t.decimal "amount", precision: 10, scale: 2
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_bills_on_identity_id"
  end

  create_table "blog_files", force: :cascade do |t|
    t.bigint "blog_id"
    t.bigint "identity_file_id"
    t.bigint "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_blog_files_on_blog_id"
    t.index ["identity_file_id"], name: "index_blog_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_blog_files_on_identity_id"
  end

  create_table "blog_posts", force: :cascade do |t|
    t.bigint "blog_id"
    t.string "blog_post_title"
    t.text "post"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["blog_id"], name: "index_blog_posts_on_blog_id"
    t.index ["identity_id"], name: "index_blog_posts_on_identity_id"
  end

  create_table "blogs", force: :cascade do |t|
    t.string "blog_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_blogs_on_identity_id"
  end

  create_table "blood_concentrations", id: :serial, force: :cascade do |t|
    t.string "concentration_name", limit: 255
    t.integer "concentration_type"
    t.decimal "concentration_minimum", precision: 10, scale: 3
    t.decimal "concentration_maximum", precision: 10, scale: 3
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.text "notes"
    t.index ["identity_id"], name: "index_blood_concentrations_on_identity_id"
  end

  create_table "blood_pressures", id: :serial, force: :cascade do |t|
    t.integer "systolic_pressure"
    t.integer "diastolic_pressure"
    t.date "measurement_date"
    t.string "measurement_source", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_blood_pressures_on_identity_id"
  end

  create_table "blood_test_files", id: :serial, force: :cascade do |t|
    t.integer "blood_test_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["blood_test_id"], name: "index_blood_test_files_on_blood_test_id"
    t.index ["identity_file_id"], name: "index_blood_test_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_blood_test_files_on_identity_id"
  end

  create_table "blood_test_results", id: :serial, force: :cascade do |t|
    t.integer "blood_test_id"
    t.integer "blood_concentration_id"
    t.decimal "concentration", precision: 10, scale: 3
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.integer "flag"
    t.index ["blood_concentration_id"], name: "index_blood_test_results_on_blood_concentration_id"
    t.index ["blood_test_id"], name: "index_blood_test_results_on_blood_test_id"
    t.index ["identity_id"], name: "index_blood_test_results_on_identity_id"
  end

  create_table "blood_tests", id: :serial, force: :cascade do |t|
    t.datetime "fast_started"
    t.datetime "test_time"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.integer "doctor_id"
    t.integer "location_id"
    t.datetime "archived"
    t.integer "rating"
    t.string "preceding_changes"
    t.index ["doctor_id"], name: "index_blood_tests_on_doctor_id"
    t.index ["identity_id"], name: "index_blood_tests_on_identity_id"
    t.index ["location_id"], name: "index_blood_tests_on_location_id"
  end

  create_table "book_files", id: :serial, force: :cascade do |t|
    t.integer "book_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["book_id"], name: "index_book_files_on_book_id"
    t.index ["identity_file_id"], name: "index_book_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_book_files_on_identity_id"
  end

  create_table "book_quotes", id: :serial, force: :cascade do |t|
    t.integer "book_id"
    t.string "pages"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "quote_id"
    t.index ["book_id"], name: "index_book_quotes_on_book_id"
    t.index ["identity_id"], name: "index_book_quotes_on_identity_id"
    t.index ["quote_id"], name: "index_book_quotes_on_quote_id"
  end

  create_table "book_stores", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "rating"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.index ["identity_id"], name: "index_book_stores_on_identity_id"
    t.index ["location_id"], name: "index_book_stores_on_location_id"
  end

  create_table "books", id: :serial, force: :cascade do |t|
    t.string "book_name", limit: 255
    t.string "isbn", limit: 255
    t.string "author", limit: 255
    t.datetime "when_read"
    t.integer "identity_id"
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.integer "recommender_id"
    t.text "review"
    t.integer "lent_to_id"
    t.date "lent_date"
    t.integer "borrowed_from_id"
    t.date "borrowed_date"
    t.datetime "archived"
    t.integer "rating"
    t.string "book_category"
    t.date "acquired"
    t.datetime "when_owned"
    t.datetime "when_discarded"
    t.integer "gift_from_id"
    t.string "book_location"
    t.index ["borrowed_from_id"], name: "index_books_on_borrowed_from_id"
    t.index ["gift_from_id"], name: "index_books_on_gift_from_id"
    t.index ["identity_id"], name: "index_books_on_identity_id"
    t.index ["lent_to_id"], name: "index_books_on_lent_to_id"
    t.index ["recommender_id"], name: "index_books_on_recommender_id"
  end

  create_table "business_card_files", id: :serial, force: :cascade do |t|
    t.integer "business_card_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["business_card_id"], name: "index_business_card_files_on_business_card_id"
    t.index ["identity_file_id"], name: "index_business_card_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_business_card_files_on_identity_id"
  end

  create_table "business_cards", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_business_cards_on_contact_id"
    t.index ["identity_id"], name: "index_business_cards_on_identity_id"
  end

  create_table "cafes", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "rating"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.index ["identity_id"], name: "index_cafes_on_identity_id"
    t.index ["location_id"], name: "index_cafes_on_location_id"
  end

  create_table "calculation_elements", id: :serial, force: :cascade do |t|
    t.integer "left_operand_id"
    t.integer "right_operand_id"
    t.integer "operator"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_calculation_elements_on_identity_id"
    t.index ["left_operand_id"], name: "index_calculation_elements_on_left_operand_id"
    t.index ["right_operand_id"], name: "index_calculation_elements_on_right_operand_id"
  end

  create_table "calculation_forms", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "root_element_id"
    t.text "equation"
    t.boolean "is_duplicate"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_calculation_forms_on_identity_id"
    t.index ["root_element_id"], name: "index_calculation_forms_on_root_element_id"
  end

  create_table "calculation_inputs", id: :serial, force: :cascade do |t|
    t.string "input_name", limit: 255
    t.string "input_value", limit: 255
    t.integer "calculation_form_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "variable_name", limit: 255
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calculation_form_id"], name: "index_calculation_inputs_on_calculation_form_id"
    t.index ["identity_id"], name: "index_calculation_inputs_on_identity_id"
  end

  create_table "calculation_operands", id: :serial, force: :cascade do |t|
    t.string "constant_value", limit: 255
    t.integer "calculation_element_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "calculation_input_id"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calculation_element_id"], name: "index_calculation_operands_on_calculation_element_id"
    t.index ["identity_id"], name: "index_calculation_operands_on_identity_id"
  end

  create_table "calculations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "calculation_form_id"
    t.decimal "result", precision: 10, scale: 2
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "original_calculation_form_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calculation_form_id"], name: "index_calculations_on_calculation_form_id"
    t.index ["identity_id"], name: "index_calculations_on_identity_id"
  end

  create_table "calendar_item_reminder_pendings", id: :serial, force: :cascade do |t|
    t.integer "calendar_item_reminder_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "calendar_id"
    t.integer "calendar_item_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calendar_id"], name: "index_calendar_item_reminder_pendings_on_calendar_id"
    t.index ["calendar_item_id"], name: "index_calendar_item_reminder_pendings_on_calendar_item_id"
    t.index ["calendar_item_reminder_id"], name: "index_calendar_item_reminder_pendings_on_cir_id"
    t.index ["identity_id"], name: "index_calendar_item_reminder_pendings_on_identity_id"
  end

  create_table "calendar_item_reminders", id: :serial, force: :cascade do |t|
    t.integer "threshold_amount"
    t.integer "threshold_type"
    t.integer "repeat_amount"
    t.integer "repeat_type"
    t.integer "expire_amount"
    t.integer "expire_type"
    t.integer "calendar_item_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "max_pending"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calendar_item_id"], name: "index_calendar_item_reminders_on_calendar_item_id"
    t.index ["identity_id"], name: "index_calendar_item_reminders_on_identity_id"
  end

  create_table "calendar_items", id: :serial, force: :cascade do |t|
    t.integer "calendar_id"
    t.datetime "calendar_item_time"
    t.text "notes"
    t.boolean "persistent"
    t.integer "repeat_amount"
    t.integer "repeat_type"
    t.string "model_class"
    t.integer "model_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "context_info"
    t.boolean "is_repeat"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calendar_id"], name: "index_calendar_items_on_calendar_id"
    t.index ["identity_id"], name: "index_calendar_items_on_identity_id"
  end

  create_table "calendars", id: :serial, force: :cascade do |t|
    t.boolean "trash"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.integer "exercise_threshold"
    t.integer "contact_best_friend_threshold"
    t.integer "contact_good_friend_threshold"
    t.integer "contact_acquaintance_threshold"
    t.integer "contact_best_family_threshold"
    t.integer "contact_good_family_threshold"
    t.integer "dentist_visit_threshold"
    t.integer "doctor_visit_threshold"
    t.integer "status_threshold"
    t.integer "trash_pickup_threshold"
    t.integer "periodic_payment_before_threshold"
    t.integer "periodic_payment_after_threshold"
    t.integer "drivers_license_expiration_threshold"
    t.integer "birthday_threshold"
    t.integer "promotion_threshold"
    t.integer "gun_registration_expiration_threshold"
    t.integer "event_threshold"
    t.integer "stocks_vest_threshold"
    t.integer "todo_threshold"
    t.integer "vehicle_service_threshold"
    t.integer "reminder_repeat_amount"
    t.integer "reminder_repeat_type"
    t.integer "general_threshold"
    t.integer "happy_things_threshold"
    t.integer "website_domain_registration_threshold"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_calendars_on_identity_id"
  end

  create_table "camp_locations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.boolean "vehicle_parking"
    t.boolean "free"
    t.boolean "sewage"
    t.boolean "fresh_water"
    t.boolean "electricity"
    t.boolean "internet"
    t.boolean "trash"
    t.boolean "shower"
    t.boolean "bathroom"
    t.integer "noise_level"
    t.integer "rating"
    t.boolean "overnight_allowed"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.boolean "boondocking"
    t.boolean "cell_phone_reception"
    t.boolean "cell_phone_data"
    t.integer "membership_id"
    t.datetime "archived"
    t.boolean "chance_high_wind"
    t.boolean "birds_chirping"
    t.boolean "near_busy_road"
    t.boolean "level_ground"
    t.index ["identity_id"], name: "index_camp_locations_on_identity_id"
    t.index ["location_id"], name: "index_camp_locations_on_location_id"
    t.index ["membership_id"], name: "index_camp_locations_on_membership_id"
  end

  create_table "cashbacks", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.decimal "cashback_percentage", precision: 10, scale: 2
    t.string "applies_to", limit: 255
    t.date "start_date"
    t.date "end_date"
    t.decimal "yearly_maximum", precision: 10, scale: 2
    t.text "notes"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean "default_cashback"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_cashbacks_on_identity_id"
  end

  create_table "categories", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "link", limit: 255
    t.integer "position"
    t.integer "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "additional_filtertext", limit: 255
    t.string "icon", limit: 255
    t.boolean "explicit"
    t.integer "user_type_mask"
    t.boolean "experimental"
    t.boolean "simple"
    t.index ["name"], name: "index_categories_on_name", unique: true
    t.index ["parent_id"], name: "index_categories_on_parent_id"
  end

  create_table "category_permissions", force: :cascade do |t|
    t.integer "action"
    t.string "subject_class"
    t.bigint "user_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "target_identity_id"
    t.index ["identity_id"], name: "index_category_permissions_on_identity_id"
    t.index ["target_identity_id"], name: "index_category_permissions_on_target_identity_id"
    t.index ["user_id"], name: "index_category_permissions_on_user_id"
  end

  create_table "category_points_amounts", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "category_id"
    t.integer "count"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visits"
    t.datetime "last_visit"
    t.datetime "archived"
    t.integer "rating"
    t.index ["category_id"], name: "index_category_points_amounts_on_category_id"
    t.index ["identity_id"], name: "index_category_points_amounts_on_identity_id"
  end

  create_table "charities", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.text "notes"
    t.integer "rating"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.index ["identity_id"], name: "index_charities_on_identity_id"
    t.index ["location_id"], name: "index_charities_on_location_id"
  end

  create_table "check_files", id: :serial, force: :cascade do |t|
    t.integer "check_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["check_id"], name: "index_check_files_on_check_id"
    t.index ["identity_file_id"], name: "index_check_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_check_files_on_identity_id"
  end

  create_table "checklist_items", id: :serial, force: :cascade do |t|
    t.string "checklist_item_name", limit: 255
    t.integer "checklist_id"
    t.integer "position"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["checklist_id"], name: "index_checklist_items_on_checklist_id"
    t.index ["identity_id"], name: "index_checklist_items_on_identity_id"
  end

  create_table "checklist_references", id: :serial, force: :cascade do |t|
    t.integer "checklist_parent_id"
    t.integer "checklist_id"
    t.integer "identity_id"
    t.boolean "pre_checklist"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["checklist_id"], name: "index_checklist_references_on_checklist_id"
    t.index ["checklist_parent_id"], name: "index_checklist_references_on_checklist_parent_id"
    t.index ["identity_id"], name: "index_checklist_references_on_identity_id"
  end

  create_table "checklists", id: :serial, force: :cascade do |t|
    t.string "checklist_name", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_checklists_on_identity_id"
  end

  create_table "checks", id: :serial, force: :cascade do |t|
    t.string "description"
    t.text "notes"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "contact_id"
    t.integer "company_id"
    t.date "deposit_date"
    t.date "received_date"
    t.integer "bank_account_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["bank_account_id"], name: "index_checks_on_bank_account_id"
    t.index ["company_id"], name: "index_checks_on_company_id"
    t.index ["contact_id"], name: "index_checks_on_contact_id"
    t.index ["identity_id"], name: "index_checks_on_identity_id"
  end

  create_table "companies", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "company_identity_id"
    t.index ["company_identity_id"], name: "index_companies_on_company_identity_id"
    t.index ["identity_id"], name: "index_companies_on_identity_id"
  end

  create_table "company_interaction_files", id: :serial, force: :cascade do |t|
    t.integer "company_interaction_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_interaction_id"], name: "index_company_interaction_files_on_company_interaction_id"
    t.index ["identity_file_id"], name: "index_company_interaction_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_company_interaction_files_on_identity_id"
  end

  create_table "company_interactions", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.datetime "company_interaction_date"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_company_interactions_on_company_id"
    t.index ["identity_id"], name: "index_company_interactions_on_identity_id"
  end

  create_table "complete_due_items", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.string "display", limit: 255
    t.string "link", limit: 255
    t.datetime "due_date"
    t.string "myp_model_name", limit: 255
    t.integer "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "original_due_date"
    t.integer "calendar_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calendar_id"], name: "index_complete_due_items_on_calendar_id"
    t.index ["identity_id"], name: "index_complete_due_items_on_identity_id"
  end

  create_table "computer_ssh_keys", id: :serial, force: :cascade do |t|
    t.integer "computer_id"
    t.integer "ssh_key_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "username"
    t.datetime "archived"
    t.integer "rating"
    t.index ["computer_id"], name: "index_computer_ssh_keys_on_computer_id"
    t.index ["identity_id"], name: "index_computer_ssh_keys_on_identity_id"
    t.index ["ssh_key_id"], name: "index_computer_ssh_keys_on_ssh_key_id"
  end

  create_table "computers", id: :serial, force: :cascade do |t|
    t.date "purchased"
    t.decimal "price", precision: 10, scale: 2
    t.string "computer_model", limit: 255
    t.string "serial_number", limit: 255
    t.integer "manufacturer_id"
    t.integer "max_resolution_width"
    t.integer "max_resolution_height"
    t.integer "ram"
    t.integer "num_cpus"
    t.integer "num_cores_per_cpu"
    t.boolean "hyperthreaded"
    t.decimal "max_cpu_speed", precision: 10, scale: 2
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "administrator_id"
    t.integer "main_user_id"
    t.integer "dimensions_type"
    t.decimal "width", precision: 10, scale: 2
    t.decimal "height", precision: 10, scale: 2
    t.decimal "depth", precision: 10, scale: 2
    t.integer "weight_type"
    t.decimal "weight", precision: 10, scale: 2
    t.integer "visit_count"
    t.string "hostname"
    t.datetime "archived"
    t.integer "rating"
    t.index ["administrator_id"], name: "index_computers_on_administrator_id"
    t.index ["identity_id"], name: "index_computers_on_identity_id"
    t.index ["main_user_id"], name: "index_computers_on_main_user_id"
    t.index ["manufacturer_id"], name: "index_computers_on_manufacturer_id"
  end

  create_table "concert_musical_groups", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "concert_id"
    t.integer "musical_group_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["concert_id"], name: "index_concert_musical_groups_on_concert_id"
    t.index ["identity_id"], name: "index_concert_musical_groups_on_identity_id"
    t.index ["musical_group_id"], name: "index_concert_musical_groups_on_musical_group_id"
  end

  create_table "concert_pictures", id: :serial, force: :cascade do |t|
    t.integer "concert_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["concert_id"], name: "index_concert_pictures_on_concert_id"
    t.index ["identity_file_id"], name: "index_concert_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_concert_pictures_on_identity_id"
  end

  create_table "concerts", id: :serial, force: :cascade do |t|
    t.string "concert_date", limit: 255
    t.string "concert_title", limit: 255
    t.integer "location_id"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_concerts_on_identity_id"
    t.index ["location_id"], name: "index_concerts_on_location_id"
  end

  create_table "connections", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.integer "connection_status"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "connection_request_token"
    t.integer "contact_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_connections_on_contact_id"
    t.index ["identity_id"], name: "index_connections_on_identity_id"
    t.index ["user_id"], name: "index_connections_on_user_id"
  end

  create_table "consumed_foods", force: :cascade do |t|
    t.datetime "consumed_food_time"
    t.bigint "food_id"
    t.decimal "quantity", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_consumed_foods_on_food_id"
    t.index ["identity_id"], name: "index_consumed_foods_on_identity_id"
  end

  create_table "contacts", id: :serial, force: :cascade do |t|
    t.integer "contact_identity_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "contact_type"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "contact_preference"
    t.index ["contact_identity_id"], name: "index_contacts_on_contact_identity_id"
    t.index ["identity_id"], name: "index_contacts_on_identity_id"
  end

  create_table "conversation_files", id: :serial, force: :cascade do |t|
    t.integer "conversation_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["conversation_id"], name: "index_conversation_files_on_conversation_id"
    t.index ["identity_file_id"], name: "index_conversation_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_conversation_files_on_identity_id"
  end

  create_table "conversations", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.text "conversation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.date "conversation_date"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_conversations_on_contact_id"
    t.index ["identity_id"], name: "index_conversations_on_identity_id"
  end

  create_table "credit_card_cashbacks", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "credit_card_id"
    t.integer "cashback_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["cashback_id"], name: "index_credit_card_cashbacks_on_cashback_id"
    t.index ["credit_card_id"], name: "index_credit_card_cashbacks_on_credit_card_id"
    t.index ["identity_id"], name: "index_credit_card_cashbacks_on_identity_id"
  end

  create_table "credit_card_files", id: :serial, force: :cascade do |t|
    t.integer "credit_card_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_card_id"], name: "index_credit_card_files_on_credit_card_id"
    t.index ["identity_file_id"], name: "index_credit_card_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_credit_card_files_on_identity_id"
  end

  create_table "credit_cards", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "number", limit: 255
    t.date "expires"
    t.string "security_code", limit: 255
    t.integer "password_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "pin", limit: 255
    t.text "notes"
    t.integer "address_id"
    t.integer "number_encrypted_id"
    t.integer "security_code_encrypted_id"
    t.integer "pin_encrypted_id"
    t.integer "expires_encrypted_id"
    t.datetime "archived"
    t.integer "card_type"
    t.decimal "total_credit", precision: 10, scale: 2
    t.integer "visit_count"
    t.boolean "email_reminders"
    t.integer "rating"
    t.date "start_date"
    t.index ["address_id"], name: "index_credit_cards_on_address_id"
    t.index ["expires_encrypted_id"], name: "index_credit_cards_on_expires_encrypted_id"
    t.index ["identity_id"], name: "index_credit_cards_on_identity_id"
    t.index ["number_encrypted_id"], name: "index_credit_cards_on_number_encrypted_id"
    t.index ["password_id"], name: "index_credit_cards_on_password_id"
    t.index ["pin_encrypted_id"], name: "index_credit_cards_on_pin_encrypted_id"
    t.index ["security_code_encrypted_id"], name: "index_credit_cards_on_security_code_encrypted_id"
  end

  create_table "credit_score_files", id: :serial, force: :cascade do |t|
    t.integer "credit_score_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["credit_score_id"], name: "index_credit_score_files_on_credit_score_id"
    t.index ["identity_file_id"], name: "index_credit_score_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_credit_score_files_on_identity_id"
  end

  create_table "credit_scores", id: :serial, force: :cascade do |t|
    t.date "score_date"
    t.integer "score"
    t.string "source", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_credit_scores_on_identity_id"
  end

  create_table "date_locations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_date_locations_on_identity_id"
    t.index ["location_id"], name: "index_date_locations_on_location_id"
  end

  create_table "dating_profile_files", id: :serial, force: :cascade do |t|
    t.integer "dating_profile_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dating_profile_id"], name: "index_dating_profile_files_on_dating_profile_id"
    t.index ["identity_file_id"], name: "index_dating_profile_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_dating_profile_files_on_identity_id"
  end

  create_table "dating_profiles", id: :serial, force: :cascade do |t|
    t.string "dating_profile_name"
    t.text "about_me"
    t.text "looking_for"
    t.text "movies"
    t.text "books"
    t.text "music"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_dating_profiles_on_identity_id"
  end

  create_table "delayed_jobs", id: :serial, force: :cascade do |t|
    t.integer "priority", default: 0, null: false
    t.integer "attempts", default: 0, null: false
    t.text "handler", null: false
    t.text "last_error"
    t.datetime "run_at"
    t.datetime "locked_at"
    t.datetime "failed_at"
    t.string "locked_by"
    t.string "queue"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["priority", "run_at"], name: "delayed_jobs_priority"
  end

  create_table "dental_insurance_files", id: :serial, force: :cascade do |t|
    t.integer "dental_insurance_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dental_insurance_id"], name: "index_dental_insurance_files_on_dental_insurance_id"
    t.index ["identity_file_id"], name: "index_dental_insurance_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_dental_insurance_files_on_identity_id"
  end

  create_table "dental_insurances", id: :serial, force: :cascade do |t|
    t.string "insurance_name", limit: 255
    t.integer "insurance_company_id"
    t.integer "periodic_payment_id"
    t.text "notes"
    t.integer "group_company_id"
    t.integer "password_id"
    t.string "account_number", limit: 255
    t.string "group_number", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "doctor_id"
    t.integer "visit_count"
    t.integer "rating"
    t.datetime "archived"
    t.index ["doctor_id"], name: "index_dental_insurances_on_doctor_id"
    t.index ["group_company_id"], name: "index_dental_insurances_on_group_company_id"
    t.index ["identity_id"], name: "index_dental_insurances_on_identity_id"
    t.index ["insurance_company_id"], name: "index_dental_insurances_on_insurance_company_id"
    t.index ["password_id"], name: "index_dental_insurances_on_password_id"
    t.index ["periodic_payment_id"], name: "index_dental_insurances_on_periodic_payment_id"
  end

  create_table "dentist_visits", id: :serial, force: :cascade do |t|
    t.date "visit_date"
    t.integer "cavities"
    t.text "notes"
    t.integer "dentist_id"
    t.integer "dental_insurance_id"
    t.decimal "paid", precision: 10, scale: 2
    t.boolean "cleaning"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["dental_insurance_id"], name: "index_dentist_visits_on_dental_insurance_id"
    t.index ["dentist_id"], name: "index_dentist_visits_on_dentist_id"
    t.index ["identity_id"], name: "index_dentist_visits_on_identity_id"
  end

  create_table "desired_locations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "website_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_desired_locations_on_identity_id"
    t.index ["location_id"], name: "index_desired_locations_on_location_id"
    t.index ["website_id"], name: "index_desired_locations_on_website_id"
  end

  create_table "desired_products", id: :serial, force: :cascade do |t|
    t.string "product_name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_desired_products_on_identity_id"
  end

  create_table "dessert_locations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "rating"
    t.text "notes"
    t.boolean "visited"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.index ["identity_id"], name: "index_dessert_locations_on_identity_id"
    t.index ["location_id"], name: "index_dessert_locations_on_location_id"
  end

  create_table "diary_entries", id: :serial, force: :cascade do |t|
    t.datetime "diary_time"
    t.text "entry"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "diary_title", limit: 255
    t.integer "visit_count"
    t.integer "entry_encrypted_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["entry_encrypted_id"], name: "index_diary_entries_on_entry_encrypted_id"
    t.index ["identity_id"], name: "index_diary_entries_on_identity_id"
  end

  create_table "diet_foods", force: :cascade do |t|
    t.bigint "diet_id"
    t.bigint "food_id"
    t.decimal "quantity", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "food_type"
    t.index ["diet_id"], name: "index_diet_foods_on_diet_id"
    t.index ["food_id"], name: "index_diet_foods_on_food_id"
    t.index ["identity_id"], name: "index_diet_foods_on_identity_id"
  end

  create_table "dietary_requirements", force: :cascade do |t|
    t.string "dietary_requirement_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "dietary_requirement_amount", precision: 10, scale: 2
    t.integer "dietary_requirement_type"
    t.integer "dietary_requirement_context"
    t.bigint "dietary_requirements_collection_id"
    t.index ["dietary_requirements_collection_id"], name: "dr_on_drci"
    t.index ["identity_id"], name: "index_dietary_requirements_on_identity_id"
  end

  create_table "dietary_requirements_collection_files", force: :cascade do |t|
    t.bigint "dietary_requirements_collection_id"
    t.bigint "identity_file_id"
    t.bigint "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dietary_requirements_collection_id"], name: "drcf_on_drc"
    t.index ["identity_file_id"], name: "index_dietary_requirements_collection_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_dietary_requirements_collection_files_on_identity_id"
  end

  create_table "dietary_requirements_collections", force: :cascade do |t|
    t.string "dietary_requirements_collection_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_dietary_requirements_collections_on_identity_id"
  end

  create_table "diets", force: :cascade do |t|
    t.string "diet_name"
    t.bigint "dietary_requirements_collection_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["dietary_requirements_collection_id"], name: "index_diets_on_dietary_requirements_collection_id"
    t.index ["identity_id"], name: "index_diets_on_identity_id"
  end

  create_table "doctor_visit_files", id: :serial, force: :cascade do |t|
    t.integer "doctor_visit_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_visit_id"], name: "index_doctor_visit_files_on_doctor_visit_id"
    t.index ["identity_file_id"], name: "index_doctor_visit_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_doctor_visit_files_on_identity_id"
  end

  create_table "doctor_visits", id: :serial, force: :cascade do |t|
    t.date "visit_date"
    t.text "notes"
    t.integer "doctor_id"
    t.integer "health_insurance_id"
    t.decimal "paid", precision: 10, scale: 2
    t.boolean "physical"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["doctor_id"], name: "index_doctor_visits_on_doctor_id"
    t.index ["health_insurance_id"], name: "index_doctor_visits_on_health_insurance_id"
    t.index ["identity_id"], name: "index_doctor_visits_on_identity_id"
  end

  create_table "doctors", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "doctor_type"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_doctors_on_contact_id"
    t.index ["identity_id"], name: "index_doctors_on_identity_id"
  end

  create_table "document_files", id: :serial, force: :cascade do |t|
    t.integer "document_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["document_id"], name: "index_document_files_on_document_id"
    t.index ["identity_file_id"], name: "index_document_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_document_files_on_identity_id"
  end

  create_table "documents", id: :serial, force: :cascade do |t|
    t.string "document_name"
    t.text "notes"
    t.string "document_category"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "important"
    t.date "document_date"
    t.index ["identity_id"], name: "index_documents_on_identity_id"
  end

  create_table "donation_files", id: :serial, force: :cascade do |t|
    t.integer "donation_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["donation_id"], name: "index_donation_files_on_donation_id"
    t.index ["identity_file_id"], name: "index_donation_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_donation_files_on_identity_id"
  end

  create_table "donations", id: :serial, force: :cascade do |t|
    t.string "donation_name"
    t.date "donation_date"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "location_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_donations_on_identity_id"
    t.index ["location_id"], name: "index_donations_on_location_id"
  end

  create_table "drafts", id: :serial, force: :cascade do |t|
    t.string "draft_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_drafts_on_identity_id"
  end

  create_table "dreams", id: :serial, force: :cascade do |t|
    t.string "dream_name"
    t.datetime "dream_time"
    t.text "dream"
    t.integer "dream_encrypted_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "dream_encrypted_id_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["dream_encrypted_id"], name: "index_dreams_on_dream_encrypted_id"
    t.index ["dream_encrypted_id_id"], name: "index_dreams_on_dream_encrypted_id_id"
    t.index ["identity_id"], name: "index_dreams_on_identity_id"
  end

  create_table "drinks", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.string "drink_name", limit: 255
    t.text "notes"
    t.decimal "calories", precision: 10, scale: 2
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_drinks_on_identity_id"
  end

  create_table "driver_license_files", id: :serial, force: :cascade do |t|
    t.integer "driver_license_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["driver_license_id"], name: "index_driver_license_files_on_driver_license_id"
    t.index ["identity_file_id"], name: "index_driver_license_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_driver_license_files_on_identity_id"
  end

  create_table "driver_licenses", id: :serial, force: :cascade do |t|
    t.string "driver_license_identifier"
    t.date "driver_license_expires"
    t.date "driver_license_issued"
    t.string "sub_region1"
    t.integer "address_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "region"
    t.index ["address_id"], name: "index_driver_licenses_on_address_id"
    t.index ["identity_id"], name: "index_driver_licenses_on_identity_id"
  end

  create_table "due_items", id: :serial, force: :cascade do |t|
    t.string "display", limit: 255
    t.string "link", limit: 255
    t.datetime "due_date"
    t.string "myp_model_name", limit: 255
    t.integer "model_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "original_due_date"
    t.boolean "is_date_arbitrary"
    t.integer "calendar_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calendar_id"], name: "index_due_items_on_calendar_id"
    t.index ["identity_id"], name: "index_due_items_on_identity_id"
  end

  create_table "education_files", id: :serial, force: :cascade do |t|
    t.integer "education_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["education_id"], name: "index_education_files_on_education_id"
    t.index ["identity_file_id"], name: "index_education_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_education_files_on_identity_id"
  end

  create_table "educations", id: :serial, force: :cascade do |t|
    t.string "education_name"
    t.date "education_start"
    t.date "education_end"
    t.decimal "gpa", precision: 9, scale: 3
    t.integer "location_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.string "degree_name"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "degree_type"
    t.datetime "graduated"
    t.string "student_id"
    t.index ["identity_id"], name: "index_educations_on_identity_id"
    t.index ["location_id"], name: "index_educations_on_location_id"
  end

  create_table "email_accounts", id: :serial, force: :cascade do |t|
    t.integer "password_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_email_accounts_on_identity_id"
    t.index ["password_id"], name: "index_email_accounts_on_password_id"
  end

  create_table "email_contacts", id: :serial, force: :cascade do |t|
    t.integer "email_id"
    t.integer "identity_id"
    t.integer "contact_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_email_contacts_on_contact_id"
    t.index ["email_id"], name: "index_email_contacts_on_email_id"
    t.index ["identity_id"], name: "index_email_contacts_on_identity_id"
  end

  create_table "email_groups", id: :serial, force: :cascade do |t|
    t.integer "email_id"
    t.integer "group_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["email_id"], name: "index_email_groups_on_email_id"
    t.index ["group_id"], name: "index_email_groups_on_group_id"
    t.index ["identity_id"], name: "index_email_groups_on_identity_id"
  end

  create_table "email_personalizations", id: :serial, force: :cascade do |t|
    t.string "target"
    t.text "additional_text"
    t.boolean "do_send"
    t.integer "identity_id"
    t.integer "email_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["email_id"], name: "index_email_personalizations_on_email_id"
    t.index ["identity_id"], name: "index_email_personalizations_on_identity_id"
  end

  create_table "email_tokens", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "token"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identity_id"
    t.index ["identity_id"], name: "index_email_tokens_on_identity_id"
  end

  create_table "email_unsubscriptions", id: :serial, force: :cascade do |t|
    t.string "email"
    t.string "category"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "identity_id"
    t.index ["identity_id"], name: "index_email_unsubscriptions_on_identity_id"
  end

  create_table "emails", id: :serial, force: :cascade do |t|
    t.string "subject"
    t.text "body"
    t.boolean "copy_self"
    t.string "email_category"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "use_bcc"
    t.boolean "draft"
    t.boolean "personalize"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_emails_on_identity_id"
  end

  create_table "emergency_contacts", id: :serial, force: :cascade do |t|
    t.integer "email_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["email_id"], name: "index_emergency_contacts_on_email_id"
    t.index ["identity_id"], name: "index_emergency_contacts_on_identity_id"
  end

  create_table "encrypted_values", id: :serial, force: :cascade do |t|
    t.binary "val"
    t.binary "salt"
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "encryption_type"
    t.index ["user_id"], name: "index_encrypted_values_on_user_id"
  end

  create_table "event_contacts", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "contact_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_event_contacts_on_contact_id"
    t.index ["event_id"], name: "index_event_contacts_on_event_id"
    t.index ["identity_id"], name: "index_event_contacts_on_identity_id"
  end

  create_table "event_pictures", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "position"
    t.datetime "archived"
    t.integer "rating"
    t.index ["event_id"], name: "index_event_pictures_on_event_id"
    t.index ["identity_file_id"], name: "index_event_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_event_pictures_on_identity_id"
  end

  create_table "event_rsvps", id: :serial, force: :cascade do |t|
    t.integer "event_id"
    t.integer "identity_id"
    t.integer "rsvp_type"
    t.string "email"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["event_id"], name: "index_event_rsvps_on_event_id"
    t.index ["identity_id"], name: "index_event_rsvps_on_identity_id"
  end

  create_table "event_stories", force: :cascade do |t|
    t.bigint "event_id"
    t.bigint "story_id"
    t.bigint "identity_id"
    t.datetime "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["event_id"], name: "index_event_stories_on_event_id"
    t.index ["identity_id"], name: "index_event_stories_on_identity_id"
    t.index ["story_id"], name: "index_event_stories_on_story_id"
  end

  create_table "events", id: :serial, force: :cascade do |t|
    t.string "event_name", limit: 255
    t.text "notes"
    t.datetime "event_time"
    t.integer "visit_count"
    t.integer "identity_id"
    t.integer "repeat_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "event_end_time"
    t.integer "location_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_events_on_identity_id"
    t.index ["location_id"], name: "index_events_on_location_id"
    t.index ["repeat_id"], name: "index_events_on_repeat_id"
  end

  create_table "exercise_regimen_exercise_files", id: :serial, force: :cascade do |t|
    t.integer "exercise_regimen_exercise_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["exercise_regimen_exercise_id"], name: "eref_on_erei"
    t.index ["identity_file_id"], name: "index_exercise_regimen_exercise_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_exercise_regimen_exercise_files_on_identity_id"
  end

  create_table "exercise_regimen_exercises", id: :serial, force: :cascade do |t|
    t.string "exercise_regimen_exercise_name"
    t.text "notes"
    t.integer "position"
    t.integer "exercise_regimen_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["exercise_regimen_id"], name: "index_exercise_regimen_exercises_on_exercise_regimen_id"
    t.index ["identity_id"], name: "index_exercise_regimen_exercises_on_identity_id"
  end

  create_table "exercise_regimens", id: :serial, force: :cascade do |t|
    t.string "exercise_regimen_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_exercise_regimens_on_identity_id"
  end

  create_table "exercises", id: :serial, force: :cascade do |t|
    t.datetime "exercise_start"
    t.datetime "exercise_end"
    t.string "exercise_activity", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "situps"
    t.integer "pushups"
    t.integer "cardio_time"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_exercises_on_identity_id"
  end

  create_table "favorite_locations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_favorite_locations_on_identity_id"
    t.index ["location_id"], name: "index_favorite_locations_on_location_id"
  end

  create_table "favorite_product_files", id: :serial, force: :cascade do |t|
    t.integer "favorite_product_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["favorite_product_id"], name: "index_favorite_product_files_on_favorite_product_id"
    t.index ["identity_file_id"], name: "index_favorite_product_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_favorite_product_files_on_identity_id"
  end

  create_table "favorite_product_links", id: :serial, force: :cascade do |t|
    t.integer "favorite_product_id"
    t.integer "identity_id"
    t.string "link", limit: 2000
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["favorite_product_id"], name: "index_favorite_product_links_on_favorite_product_id"
    t.index ["identity_id"], name: "index_favorite_product_links_on_identity_id"
  end

  create_table "favorite_products", id: :serial, force: :cascade do |t|
    t.string "product_name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_favorite_products_on_identity_id"
  end

  create_table "feed_items", id: :serial, force: :cascade do |t|
    t.string "feed_title"
    t.integer "feed_id"
    t.string "feed_link"
    t.text "content"
    t.datetime "publication_date"
    t.string "guid"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "read"
    t.datetime "archived"
    t.integer "rating"
    t.index ["feed_id"], name: "index_feed_items_on_feed_id"
    t.index ["identity_id"], name: "index_feed_items_on_identity_id"
  end

  create_table "feed_load_statuses", id: :serial, force: :cascade do |t|
    t.integer "items_total"
    t.integer "items_complete"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "items_error"
    t.index ["identity_id"], name: "index_feed_load_statuses_on_identity_id"
  end

  create_table "feeds", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "url", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "total_items"
    t.integer "unread_items"
    t.boolean "new_notify"
    t.index ["identity_id"], name: "index_feeds_on_identity_id"
  end

  create_table "files", id: :serial, force: :cascade do |t|
    t.integer "identity_file_id"
    t.string "style", limit: 255
    t.binary "file_contents"
    t.integer "visit_count"
  end

  create_table "flight_legs", id: :serial, force: :cascade do |t|
    t.integer "flight_id"
    t.integer "flight_number"
    t.integer "flight_company_id"
    t.string "depart_airport_code"
    t.integer "depart_location_id"
    t.datetime "depart_time"
    t.string "arrival_airport_code"
    t.integer "arrival_location_id"
    t.datetime "arrive_time"
    t.string "seat_number"
    t.integer "position"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["arrival_location_id"], name: "index_flight_legs_on_arrival_location_id"
    t.index ["depart_location_id"], name: "index_flight_legs_on_depart_location_id"
    t.index ["flight_company_id"], name: "index_flight_legs_on_flight_company_id"
    t.index ["flight_id"], name: "index_flight_legs_on_flight_id"
    t.index ["identity_id"], name: "index_flight_legs_on_identity_id"
  end

  create_table "flights", id: :serial, force: :cascade do |t|
    t.string "flight_name"
    t.date "flight_start_date"
    t.string "confirmation_number"
    t.integer "visit_count"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_flights_on_identity_id"
  end

  create_table "food_files", id: :serial, force: :cascade do |t|
    t.integer "food_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_food_files_on_food_id"
    t.index ["identity_file_id"], name: "index_food_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_food_files_on_identity_id"
  end

  create_table "food_informations", force: :cascade do |t|
    t.string "food_name"
    t.text "notes"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "usda_food_nutrient_databank_number"
    t.string "usda_weight_nutrient_databank_number"
    t.string "usda_weight_sequence_number"
    t.index ["identity_id"], name: "index_food_informations_on_identity_id"
  end

  create_table "food_ingredients", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "parent_food_id"
    t.integer "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["food_id"], name: "index_food_ingredients_on_food_id"
    t.index ["identity_id"], name: "index_food_ingredients_on_identity_id"
    t.index ["parent_food_id"], name: "index_food_ingredients_on_parent_food_id"
  end

  create_table "food_nutrient_informations", force: :cascade do |t|
    t.string "nutrient_name"
    t.string "usda_nutrient_nutrient_number"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_food_nutrient_informations_on_identity_id"
  end

  create_table "food_nutrition_information_amounts", force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.integer "measurement_type"
    t.bigint "nutrient_id"
    t.bigint "food_nutrition_information_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_nutrition_information_id"], name: "fnia_on_fni"
    t.index ["identity_id"], name: "index_food_nutrition_information_amounts_on_identity_id"
    t.index ["nutrient_id"], name: "index_food_nutrition_information_amounts_on_nutrient_id"
  end

  create_table "food_nutrition_information_files", force: :cascade do |t|
    t.bigint "food_nutrition_information_id"
    t.bigint "identity_file_id"
    t.bigint "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_nutrition_information_id"], name: "fnif_on_fni"
    t.index ["identity_file_id"], name: "index_food_nutrition_information_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_food_nutrition_information_files_on_identity_id"
  end

  create_table "food_nutrition_informations", force: :cascade do |t|
    t.decimal "serving_size", precision: 10, scale: 2
    t.decimal "servings_per_container", precision: 10, scale: 2
    t.decimal "calories_per_serving", precision: 10, scale: 2
    t.decimal "calories_per_serving_from_fat", precision: 10, scale: 2
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "serving_size_type"
    t.index ["identity_id"], name: "index_food_nutrition_informations_on_identity_id"
  end

  create_table "foods", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.string "food_name", limit: 255
    t.text "notes"
    t.decimal "calories", precision: 10, scale: 2
    t.decimal "price", precision: 10, scale: 2
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "weight_type"
    t.decimal "weight", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "food_nutrition_information_id"
    t.bigint "food_information_id"
    t.index ["food_information_id"], name: "index_foods_on_food_information_id"
    t.index ["food_nutrition_information_id"], name: "index_foods_on_food_nutrition_information_id"
    t.index ["identity_id"], name: "index_foods_on_identity_id"
  end

  create_table "gas_stations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.boolean "gas"
    t.boolean "diesel"
    t.boolean "propane_replacement"
    t.boolean "propane_fillup"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.text "notes"
    t.boolean "rv_dump_station"
    t.index ["identity_id"], name: "index_gas_stations_on_identity_id"
    t.index ["location_id"], name: "index_gas_stations_on_location_id"
  end

  create_table "group_contacts", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "group_id"
    t.integer "contact_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_group_contacts_on_contact_id"
    t.index ["group_id"], name: "index_group_contacts_on_group_id"
    t.index ["identity_id"], name: "index_group_contacts_on_identity_id"
  end

  create_table "group_references", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "parent_group_id"
    t.integer "group_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["group_id"], name: "index_group_references_on_group_id"
    t.index ["identity_id"], name: "index_group_references_on_identity_id"
    t.index ["parent_group_id"], name: "index_group_references_on_parent_group_id"
  end

  create_table "groups", id: :serial, force: :cascade do |t|
    t.string "group_name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_groups_on_identity_id"
  end

  create_table "gun_files", id: :serial, force: :cascade do |t|
    t.integer "gun_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gun_id"], name: "index_gun_files_on_gun_id"
    t.index ["identity_file_id"], name: "index_gun_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_gun_files_on_identity_id"
  end

  create_table "gun_registration_files", id: :serial, force: :cascade do |t|
    t.integer "gun_registration_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["gun_registration_id"], name: "index_gun_registration_files_on_gun_registration_id"
    t.index ["identity_file_id"], name: "index_gun_registration_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_gun_registration_files_on_identity_id"
  end

  create_table "gun_registrations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.date "registered"
    t.date "expires"
    t.integer "gun_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["gun_id"], name: "index_gun_registrations_on_gun_id"
    t.index ["identity_id"], name: "index_gun_registrations_on_identity_id"
    t.index ["location_id"], name: "index_gun_registrations_on_location_id"
  end

  create_table "guns", id: :serial, force: :cascade do |t|
    t.string "gun_name", limit: 255
    t.string "manufacturer_name", limit: 255
    t.string "gun_model", limit: 255
    t.decimal "bullet_caliber", precision: 10, scale: 2
    t.integer "max_bullets"
    t.decimal "price", precision: 10, scale: 2
    t.date "purchased"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_guns_on_identity_id"
  end

  create_table "happy_things", id: :serial, force: :cascade do |t|
    t.string "happy_thing_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_happy_things_on_identity_id"
  end

  create_table "headaches", id: :serial, force: :cascade do |t|
    t.datetime "started"
    t.datetime "ended"
    t.integer "intensity"
    t.string "headache_location", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_headaches_on_identity_id"
  end

  create_table "health_insurance_files", id: :serial, force: :cascade do |t|
    t.integer "health_insurance_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["health_insurance_id"], name: "index_health_insurance_files_on_health_insurance_id"
    t.index ["identity_file_id"], name: "index_health_insurance_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_health_insurance_files_on_identity_id"
  end

  create_table "health_insurances", id: :serial, force: :cascade do |t|
    t.string "insurance_name", limit: 255
    t.integer "insurance_company_id"
    t.datetime "archived"
    t.integer "periodic_payment_id"
    t.text "notes"
    t.integer "group_company_id"
    t.integer "password_id"
    t.string "account_number", limit: 255
    t.string "group_number", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "doctor_id"
    t.integer "visit_count"
    t.integer "rating"
    t.index ["doctor_id"], name: "index_health_insurances_on_doctor_id"
    t.index ["group_company_id"], name: "index_health_insurances_on_group_company_id"
    t.index ["identity_id"], name: "index_health_insurances_on_identity_id"
    t.index ["insurance_company_id"], name: "index_health_insurances_on_insurance_company_id"
    t.index ["password_id"], name: "index_health_insurances_on_password_id"
    t.index ["periodic_payment_id"], name: "index_health_insurances_on_periodic_payment_id"
  end

  create_table "heart_rates", id: :serial, force: :cascade do |t|
    t.integer "beats"
    t.date "measurement_date"
    t.string "measurement_source", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_heart_rates_on_identity_id"
  end

  create_table "heights", id: :serial, force: :cascade do |t|
    t.decimal "height_amount", precision: 10, scale: 2
    t.integer "amount_type"
    t.date "measurement_date"
    t.string "measurement_source", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_heights_on_identity_id"
  end

  create_table "hobbies", id: :serial, force: :cascade do |t|
    t.string "hobby_name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_hobbies_on_identity_id"
  end

  create_table "hospital_visit_files", id: :serial, force: :cascade do |t|
    t.integer "hospital_visit_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospital_visit_id"], name: "index_hospital_visit_files_on_hospital_visit_id"
    t.index ["identity_file_id"], name: "index_hospital_visit_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_hospital_visit_files_on_identity_id"
  end

  create_table "hospital_visits", id: :serial, force: :cascade do |t|
    t.string "hospital_visit_purpose"
    t.date "hospital_visit_date"
    t.integer "hospital_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.boolean "emergency_room"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["hospital_id"], name: "index_hospital_visits_on_hospital_id"
    t.index ["identity_id"], name: "index_hospital_visits_on_identity_id"
  end

  create_table "hotels", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "breakfast_rating"
    t.integer "overall_rating"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "room_number"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_hotels_on_identity_id"
    t.index ["location_id"], name: "index_hotels_on_location_id"
  end

  create_table "hypotheses", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "notes"
    t.integer "question_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_hypotheses_on_identity_id"
    t.index ["question_id"], name: "index_hypotheses_on_question_id"
  end

  create_table "hypothesis_experiments", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "notes"
    t.date "started"
    t.date "ended"
    t.integer "hypothesis_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["hypothesis_id"], name: "index_hypothesis_experiments_on_hypothesis_id"
    t.index ["identity_id"], name: "index_hypothesis_experiments_on_identity_id"
  end

  create_table "ideas", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "idea"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_ideas_on_identity_id"
  end

  create_table "identities", id: :serial, force: :cascade do |t|
    t.integer "user_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "points"
    t.string "name", limit: 255
    t.date "birthday"
    t.text "notes"
    t.text "notepad"
    t.string "nickname", limit: 255
    t.text "likes"
    t.text "gift_ideas"
    t.string "ktn", limit: 255
    t.text "new_years_resolution"
    t.integer "sex_type"
    t.integer "company_id"
    t.string "middle_name"
    t.string "last_name"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.string "display_note"
    t.integer "identity_type"
    t.index ["company_id"], name: "index_identities_on_company_id"
    t.index ["identity_id"], name: "index_identities_on_identity_id"
    t.index ["user_id"], name: "index_identities_on_user_id"
  end

  create_table "identity_drivers_licenses", id: :serial, force: :cascade do |t|
    t.string "identifier", limit: 255
    t.string "region", limit: 255
    t.string "sub_region1", limit: 255
    t.date "expires"
    t.integer "parent_identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["parent_identity_id"], name: "index_identity_drivers_licenses_on_parent_identity_id"
  end

  create_table "identity_emails", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255
    t.integer "parent_identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.boolean "secondary"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_identity_emails_on_identity_id"
    t.index ["parent_identity_id"], name: "index_identity_emails_on_parent_identity_id"
  end

  create_table "identity_file_folders", id: :serial, force: :cascade do |t|
    t.string "folder_name", limit: 255
    t.integer "parent_folder_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_identity_file_folders_on_identity_id"
    t.index ["parent_folder_id"], name: "index_identity_file_folders_on_parent_folder_id"
  end

  create_table "identity_files", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "file_file_name", limit: 255
    t.string "file_content_type", limit: 255
    t.integer "file_file_size"
    t.datetime "file_updated_at"
    t.integer "encrypted_password_id"
    t.text "notes"
    t.integer "folder_id"
    t.binary "thumbnail_contents"
    t.integer "thumbnail_size_bytes"
    t.integer "visit_count"
    t.string "filesystem_path"
    t.boolean "thumbnail_skip"
    t.string "file_hash"
    t.datetime "archived"
    t.integer "rating"
    t.string "thumbnail_filesystem_path"
    t.integer "thumbnail_filesystem_size"
    t.index ["encrypted_password_id"], name: "index_identity_files_on_encrypted_password_id"
    t.index ["folder_id"], name: "index_identity_files_on_folder_id"
    t.index ["identity_id"], name: "index_identity_files_on_identity_id"
  end

  create_table "identity_locations", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "parent_identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.boolean "secondary"
    t.index ["identity_id"], name: "index_identity_locations_on_identity_id"
    t.index ["location_id"], name: "index_identity_locations_on_location_id"
    t.index ["parent_identity_id"], name: "index_identity_locations_on_parent_identity_id"
  end

  create_table "identity_phones", id: :serial, force: :cascade do |t|
    t.string "number", limit: 255
    t.integer "parent_identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.integer "phone_type"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_identity_phones_on_identity_id"
    t.index ["parent_identity_id"], name: "index_identity_phones_on_parent_identity_id"
  end

  create_table "identity_pictures", id: :serial, force: :cascade do |t|
    t.integer "parent_identity_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_identity_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_identity_pictures_on_identity_id"
    t.index ["parent_identity_id"], name: "index_identity_pictures_on_parent_identity_id"
  end

  create_table "identity_relationships", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.integer "relationship_type"
    t.integer "identity_id"
    t.integer "parent_identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_identity_relationships_on_contact_id"
    t.index ["identity_id"], name: "index_identity_relationships_on_identity_id"
    t.index ["parent_identity_id"], name: "index_identity_relationships_on_parent_identity_id"
  end

  create_table "import_files", force: :cascade do |t|
    t.bigint "import_id"
    t.bigint "identity_file_id"
    t.bigint "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_import_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_import_files_on_identity_id"
    t.index ["import_id"], name: "index_import_files_on_import_id"
  end

  create_table "imports", force: :cascade do |t|
    t.string "import_name"
    t.integer "import_type"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_imports_on_identity_id"
  end

  create_table "injuries", id: :serial, force: :cascade do |t|
    t.string "injury_name"
    t.date "injury_date"
    t.integer "location_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.text "notes"
    t.index ["identity_id"], name: "index_injuries_on_identity_id"
    t.index ["location_id"], name: "index_injuries_on_location_id"
  end

  create_table "injury_files", id: :serial, force: :cascade do |t|
    t.integer "injury_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_injury_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_injury_files_on_identity_id"
    t.index ["injury_id"], name: "index_injury_files_on_injury_id"
  end

  create_table "insurance_card_files", id: :serial, force: :cascade do |t|
    t.integer "insurance_card_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_insurance_card_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_insurance_card_files_on_identity_id"
    t.index ["insurance_card_id"], name: "index_insurance_card_files_on_insurance_card_id"
  end

  create_table "insurance_cards", id: :serial, force: :cascade do |t|
    t.string "insurance_card_name"
    t.date "insurance_card_start"
    t.date "insurance_card_end"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_insurance_cards_on_identity_id"
  end

  create_table "invite_codes", id: :serial, force: :cascade do |t|
    t.string "code"
    t.integer "current_uses"
    t.integer "max_uses"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_invite_codes_on_identity_id"
  end

  create_table "invites", id: :serial, force: :cascade do |t|
    t.string "email"
    t.text "invite_body"
    t.integer "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_invites_on_user_id"
  end

  create_table "item_files", id: :serial, force: :cascade do |t|
    t.integer "item_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_item_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_item_files_on_identity_id"
    t.index ["item_id"], name: "index_item_files_on_item_id"
  end

  create_table "items", id: :serial, force: :cascade do |t|
    t.string "item_name"
    t.text "notes"
    t.string "item_location"
    t.decimal "cost", precision: 10, scale: 2
    t.date "acquired"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.date "expires"
    t.index ["identity_id"], name: "index_items_on_identity_id"
  end

  create_table "job_accomplishments", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "identity_id"
    t.string "accomplishment_title"
    t.text "accomplishment"
    t.datetime "accomplishment_time"
    t.datetime "archived"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "major"
    t.index ["identity_id"], name: "index_job_accomplishments_on_identity_id"
    t.index ["job_id"], name: "index_job_accomplishments_on_job_id"
  end

  create_table "job_awards", id: :serial, force: :cascade do |t|
    t.date "job_award_date"
    t.integer "job_id"
    t.decimal "job_award_amount", precision: 10, scale: 2
    t.string "job_award_description"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_job_awards_on_identity_id"
    t.index ["job_id"], name: "index_job_awards_on_job_id"
  end

  create_table "job_files", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_job_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_job_files_on_identity_id"
    t.index ["job_id"], name: "index_job_files_on_job_id"
  end

  create_table "job_managers", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "contact_id"
    t.integer "identity_id"
    t.date "start_date"
    t.date "end_date"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_job_managers_on_contact_id"
    t.index ["identity_id"], name: "index_job_managers_on_identity_id"
    t.index ["job_id"], name: "index_job_managers_on_job_id"
  end

  create_table "job_myreferences", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "myreference_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_job_myreferences_on_identity_id"
    t.index ["job_id"], name: "index_job_myreferences_on_job_id"
    t.index ["myreference_id"], name: "index_job_myreferences_on_myreference_id"
  end

  create_table "job_review_files", id: :serial, force: :cascade do |t|
    t.integer "job_review_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_job_review_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_job_review_files_on_identity_id"
    t.index ["job_review_id"], name: "index_job_review_files_on_job_review_id"
  end

  create_table "job_reviews", id: :serial, force: :cascade do |t|
    t.integer "job_id"
    t.integer "identity_id"
    t.date "review_date"
    t.string "company_score"
    t.integer "contact_id"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.text "self_evaluation"
    t.index ["contact_id"], name: "index_job_reviews_on_contact_id"
    t.index ["identity_id"], name: "index_job_reviews_on_identity_id"
    t.index ["job_id"], name: "index_job_reviews_on_job_id"
  end

  create_table "job_salaries", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "job_id"
    t.date "started"
    t.date "ended"
    t.text "notes"
    t.decimal "salary", precision: 10, scale: 2
    t.integer "salary_period"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "new_title"
    t.datetime "archived"
    t.integer "rating"
    t.decimal "hours_per_week", precision: 10, scale: 2
    t.index ["identity_id"], name: "index_job_salaries_on_identity_id"
    t.index ["job_id"], name: "index_job_salaries_on_job_id"
  end

  create_table "jobs", id: :serial, force: :cascade do |t|
    t.string "job_title", limit: 255
    t.integer "company_id"
    t.date "started"
    t.date "ended"
    t.integer "manager_contact_id"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "days_holiday"
    t.integer "days_vacation"
    t.string "employee_identifier", limit: 255
    t.string "department_name", limit: 255
    t.string "division_name", limit: 255
    t.string "business_unit", limit: 255
    t.string "email", limit: 255
    t.string "internal_mail_id", limit: 255
    t.string "internal_mail_server", limit: 255
    t.integer "internal_address_id"
    t.string "department_identifier", limit: 255
    t.string "division_identifier", limit: 255
    t.string "personnel_code", limit: 255
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.decimal "hours_per_week", precision: 10, scale: 2
    t.index ["company_id"], name: "index_jobs_on_company_id"
    t.index ["identity_id"], name: "index_jobs_on_identity_id"
    t.index ["internal_address_id"], name: "index_jobs_on_internal_address_id"
    t.index ["manager_contact_id"], name: "index_jobs_on_manager_contact_id"
  end

  create_table "jokes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "joke"
    t.string "source", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_jokes_on_identity_id"
  end

  create_table "last_text_messages", force: :cascade do |t|
    t.string "phone_number"
    t.string "category"
    t.bigint "from_identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "to_identity_id"
    t.index ["from_identity_id"], name: "index_last_text_messages_on_from_identity_id"
    t.index ["phone_number"], name: "index_last_text_messages_on_phone_number"
    t.index ["to_identity_id"], name: "index_last_text_messages_on_to_identity_id"
  end

  create_table "life_goals", id: :serial, force: :cascade do |t|
    t.string "life_goal_name", limit: 255
    t.text "notes"
    t.integer "position"
    t.datetime "goal_started"
    t.datetime "goal_ended"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.boolean "long_term"
    t.index ["identity_id"], name: "index_life_goals_on_identity_id"
  end

  create_table "life_highlight_files", id: :serial, force: :cascade do |t|
    t.integer "life_highlight_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_life_highlight_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_life_highlight_files_on_identity_id"
    t.index ["life_highlight_id"], name: "index_life_highlight_files_on_life_highlight_id"
  end

  create_table "life_highlights", id: :serial, force: :cascade do |t|
    t.datetime "life_highlight_time"
    t.string "life_highlight_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_life_highlights_on_identity_id"
  end

  create_table "life_insurance_files", id: :serial, force: :cascade do |t|
    t.integer "life_insurance_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_life_insurance_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_life_insurance_files_on_identity_id"
    t.index ["life_insurance_id"], name: "index_life_insurance_files_on_life_insurance_id"
  end

  create_table "life_insurances", id: :serial, force: :cascade do |t|
    t.string "insurance_name", limit: 255
    t.integer "company_id"
    t.decimal "insurance_amount", precision: 10, scale: 2
    t.date "started"
    t.integer "periodic_payment_id"
    t.text "notes"
    t.integer "identity_id"
    t.integer "life_insurance_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.decimal "cash_value", precision: 10, scale: 2
    t.integer "beneficiary_id"
    t.decimal "loan_interest_rate", precision: 10, scale: 2
    t.index ["beneficiary_id"], name: "index_life_insurances_on_beneficiary_id"
    t.index ["company_id"], name: "index_life_insurances_on_company_id"
    t.index ["identity_id"], name: "index_life_insurances_on_identity_id"
    t.index ["periodic_payment_id"], name: "index_life_insurances_on_periodic_payment_id"
  end

  create_table "list_items", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "list_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_list_items_on_identity_id"
    t.index ["list_id"], name: "index_list_items_on_list_id"
  end

  create_table "lists", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_lists_on_identity_id"
  end

  create_table "loans", id: :serial, force: :cascade do |t|
    t.string "lender", limit: 255
    t.decimal "amount", precision: 10, scale: 2
    t.date "start"
    t.date "paid_off"
    t.decimal "monthly_payment", precision: 10, scale: 2
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_loans_on_identity_id"
  end

  create_table "location_phones", id: :serial, force: :cascade do |t|
    t.string "number", limit: 255
    t.integer "location_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_location_phones_on_identity_id"
    t.index ["location_id"], name: "index_location_phones_on_location_id"
  end

  create_table "location_pictures", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_location_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_location_pictures_on_identity_id"
    t.index ["location_id"], name: "index_location_pictures_on_location_id"
  end

  create_table "locations", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "address1", limit: 255
    t.string "address2", limit: 255
    t.string "address3", limit: 255
    t.string "region", limit: 255
    t.string "sub_region1", limit: 255
    t.string "sub_region2", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "postal_code", limit: 255
    t.text "notes"
    t.decimal "latitude", precision: 24, scale: 20
    t.decimal "longitude", precision: 24, scale: 20
    t.integer "visit_count"
    t.integer "website_id"
    t.datetime "archived"
    t.integer "rating"
    t.integer "time_from_home"
    t.index ["identity_id"], name: "index_locations_on_identity_id"
    t.index ["website_id"], name: "index_locations_on_website_id"
  end

  create_table "meadows", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "rating"
    t.integer "visit_count"
    t.integer "identity_id"
    t.text "notes"
    t.boolean "visited"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.index ["identity_id"], name: "index_meadows_on_identity_id"
    t.index ["location_id"], name: "index_meadows_on_location_id"
  end

  create_table "meal_drinks", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "meal_id"
    t.integer "drink_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "drink_servings", precision: 10, scale: 2
    t.datetime "archived"
    t.integer "rating"
    t.index ["drink_id"], name: "index_meal_drinks_on_drink_id"
    t.index ["identity_id"], name: "index_meal_drinks_on_identity_id"
    t.index ["meal_id"], name: "index_meal_drinks_on_meal_id"
  end

  create_table "meal_foods", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "meal_id"
    t.integer "food_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "food_servings", precision: 10, scale: 2
    t.datetime "archived"
    t.integer "rating"
    t.index ["food_id"], name: "index_meal_foods_on_food_id"
    t.index ["identity_id"], name: "index_meal_foods_on_identity_id"
    t.index ["meal_id"], name: "index_meal_foods_on_meal_id"
  end

  create_table "meal_vitamins", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "meal_id"
    t.integer "vitamin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_meal_vitamins_on_identity_id"
    t.index ["meal_id"], name: "index_meal_vitamins_on_meal_id"
    t.index ["vitamin_id"], name: "index_meal_vitamins_on_vitamin_id"
  end

  create_table "meals", id: :serial, force: :cascade do |t|
    t.datetime "meal_time"
    t.text "notes"
    t.integer "location_id"
    t.decimal "price", precision: 10, scale: 2
    t.decimal "calories", precision: 10, scale: 2
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_meals_on_identity_id"
    t.index ["location_id"], name: "index_meals_on_location_id"
  end

  create_table "media_dump_files", id: :serial, force: :cascade do |t|
    t.integer "media_dump_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_media_dump_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_media_dump_files_on_identity_id"
    t.index ["media_dump_id"], name: "index_media_dump_files_on_media_dump_id"
  end

  create_table "media_dumps", id: :serial, force: :cascade do |t|
    t.string "media_dump_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_media_dumps_on_identity_id"
  end

  create_table "medical_condition_evaluation_files", id: :serial, force: :cascade do |t|
    t.integer "medical_condition_evaluation_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_medical_condition_evaluation_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_medical_condition_evaluation_files_on_identity_id"
    t.index ["medical_condition_evaluation_id"], name: "mcef_on_mcei"
  end

  create_table "medical_condition_evaluations", id: :serial, force: :cascade do |t|
    t.integer "medical_condition_id"
    t.text "notes"
    t.datetime "evaluation_datetime"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_medical_condition_evaluations_on_identity_id"
    t.index ["medical_condition_id"], name: "index_medical_condition_evaluations_on_medical_condition_id"
  end

  create_table "medical_condition_files", id: :serial, force: :cascade do |t|
    t.integer "medical_condition_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_medical_condition_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_medical_condition_files_on_identity_id"
    t.index ["medical_condition_id"], name: "index_medical_condition_files_on_medical_condition_id"
  end

  create_table "medical_condition_instances", id: :serial, force: :cascade do |t|
    t.datetime "condition_start"
    t.datetime "condition_end"
    t.text "notes"
    t.integer "medical_condition_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_medical_condition_instances_on_identity_id"
    t.index ["medical_condition_id"], name: "index_medical_condition_instances_on_medical_condition_id"
  end

  create_table "medical_condition_treatments", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "medical_condition_id"
    t.date "treatment_date"
    t.text "notes"
    t.string "treatment_description"
    t.integer "doctor_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "location_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["doctor_id"], name: "index_medical_condition_treatments_on_doctor_id"
    t.index ["identity_id"], name: "index_medical_condition_treatments_on_identity_id"
    t.index ["location_id"], name: "index_medical_condition_treatments_on_location_id"
    t.index ["medical_condition_id"], name: "index_medical_condition_treatments_on_medical_condition_id"
  end

  create_table "medical_conditions", id: :serial, force: :cascade do |t|
    t.string "medical_condition_name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_medical_conditions_on_identity_id"
  end

  create_table "medicine_usage_medicines", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "medicine_usage_id"
    t.integer "medicine_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_medicine_usage_medicines_on_identity_id"
    t.index ["medicine_id"], name: "index_medicine_usage_medicines_on_medicine_id"
    t.index ["medicine_usage_id"], name: "index_medicine_usage_medicines_on_medicine_usage_id"
  end

  create_table "medicine_usages", id: :serial, force: :cascade do |t|
    t.datetime "usage_time"
    t.integer "medicine_id"
    t.text "usage_notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_medicine_usages_on_identity_id"
    t.index ["medicine_id"], name: "index_medicine_usages_on_medicine_id"
  end

  create_table "medicines", id: :serial, force: :cascade do |t|
    t.string "medicine_name", limit: 255
    t.decimal "dosage", precision: 10, scale: 2
    t.integer "dosage_type"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_medicines_on_identity_id"
  end

  create_table "membership_files", id: :serial, force: :cascade do |t|
    t.integer "membership_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_membership_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_membership_files_on_identity_id"
    t.index ["membership_id"], name: "index_membership_files_on_membership_id"
  end

  create_table "memberships", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.date "start_date"
    t.date "end_date"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.text "notes"
    t.integer "periodic_payment_id"
    t.integer "visit_count"
    t.string "membership_identifier", limit: 255
    t.datetime "archived"
    t.integer "rating"
    t.integer "password_id"
    t.index ["identity_id"], name: "index_memberships_on_identity_id"
    t.index ["password_id"], name: "index_memberships_on_password_id"
    t.index ["periodic_payment_id"], name: "index_memberships_on_periodic_payment_id"
  end

  create_table "memories", id: :serial, force: :cascade do |t|
    t.string "memory_name"
    t.date "memory_date"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "feeling"
    t.index ["identity_id"], name: "index_memories_on_identity_id"
  end

  create_table "memory_files", id: :serial, force: :cascade do |t|
    t.integer "memory_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_memory_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_memory_files_on_identity_id"
    t.index ["memory_id"], name: "index_memory_files_on_memory_id"
  end

  create_table "message_contacts", id: :serial, force: :cascade do |t|
    t.integer "message_id"
    t.integer "contact_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_message_contacts_on_contact_id"
    t.index ["identity_id"], name: "index_message_contacts_on_identity_id"
    t.index ["message_id"], name: "index_message_contacts_on_message_id"
  end

  create_table "message_groups", id: :serial, force: :cascade do |t|
    t.integer "message_id"
    t.integer "group_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["group_id"], name: "index_message_groups_on_group_id"
    t.index ["identity_id"], name: "index_message_groups_on_identity_id"
    t.index ["message_id"], name: "index_message_groups_on_message_id"
  end

  create_table "messages", id: :serial, force: :cascade do |t|
    t.text "body"
    t.boolean "copy_self"
    t.string "message_category"
    t.boolean "draft"
    t.boolean "personalize"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "subject"
    t.datetime "archived"
    t.integer "rating"
    t.text "long_body"
    t.integer "send_preferences"
    t.index ["identity_id"], name: "index_messages_on_identity_id"
  end

  create_table "money_balance_item_templates", id: :serial, force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.decimal "original_amount", precision: 10, scale: 2
    t.string "money_balance_item_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.integer "money_balance_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_money_balance_item_templates_on_identity_id"
    t.index ["money_balance_id"], name: "index_money_balance_item_templates_on_money_balance_id"
  end

  create_table "money_balance_items", id: :serial, force: :cascade do |t|
    t.integer "money_balance_id"
    t.integer "identity_id"
    t.decimal "amount", precision: 10, scale: 2
    t.datetime "item_time"
    t.string "money_balance_item_name"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "original_amount", precision: 10, scale: 2
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_money_balance_items_on_identity_id"
    t.index ["money_balance_id"], name: "index_money_balance_items_on_money_balance_id"
  end

  create_table "money_balances", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_money_balances_on_contact_id"
    t.index ["identity_id"], name: "index_money_balances_on_identity_id"
  end

  create_table "movie_theaters", id: :serial, force: :cascade do |t|
    t.string "theater_name", limit: 255
    t.integer "location_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_movie_theaters_on_identity_id"
    t.index ["location_id"], name: "index_movie_theaters_on_location_id"
  end

  create_table "movies", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.datetime "watched"
    t.string "url", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.integer "recommender_id"
    t.string "genre"
    t.datetime "archived"
    t.integer "rating"
    t.text "review"
    t.integer "lent_to_id"
    t.date "lent_date"
    t.integer "borrowed_from_id"
    t.date "borrowed_date"
    t.datetime "when_owned"
    t.datetime "when_discarded"
    t.integer "media_type"
    t.integer "number_of_media"
    t.index ["borrowed_from_id"], name: "index_movies_on_borrowed_from_id"
    t.index ["identity_id"], name: "index_movies_on_identity_id"
    t.index ["lent_to_id"], name: "index_movies_on_lent_to_id"
    t.index ["recommender_id"], name: "index_movies_on_recommender_id"
  end

  create_table "museums", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.string "museum_id", limit: 255
    t.integer "website_id"
    t.integer "museum_type"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "museum_source", limit: 255
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_museums_on_identity_id"
    t.index ["location_id"], name: "index_museums_on_location_id"
    t.index ["website_id"], name: "index_museums_on_website_id"
  end

  create_table "music_album_files", id: :serial, force: :cascade do |t|
    t.integer "music_album_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_music_album_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_music_album_files_on_identity_id"
    t.index ["music_album_id"], name: "index_music_album_files_on_music_album_id"
  end

  create_table "music_albums", id: :serial, force: :cascade do |t|
    t.string "music_album_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_music_albums_on_identity_id"
  end

  create_table "musical_groups", id: :serial, force: :cascade do |t|
    t.string "musical_group_name", limit: 255
    t.text "notes"
    t.datetime "listened"
    t.integer "rating"
    t.boolean "awesome"
    t.boolean "secret"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "musical_genre", limit: 255
    t.integer "visit_count"
    t.datetime "archived"
    t.index ["identity_id"], name: "index_musical_groups_on_identity_id"
  end

  create_table "myplaceonline_quick_category_displays", id: :serial, force: :cascade do |t|
    t.boolean "trash"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_myplaceonline_quick_category_displays_on_identity_id"
  end

  create_table "myplaceonline_searches", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.boolean "trash"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_myplaceonline_searches_on_identity_id"
  end

  create_table "myplets", id: :serial, force: :cascade do |t|
    t.integer "x_coordinate"
    t.integer "y_coordinate"
    t.string "title", limit: 255
    t.string "category_name", limit: 255
    t.integer "category_id"
    t.integer "border_type"
    t.boolean "collapsed"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_myplets_on_identity_id"
  end

  create_table "myreferences", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.text "notes"
    t.integer "reference_type"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.string "reference_relationship"
    t.decimal "years_experience", precision: 10, scale: 2
    t.boolean "can_contact"
    t.index ["contact_id"], name: "index_myreferences_on_contact_id"
    t.index ["identity_id"], name: "index_myreferences_on_identity_id"
  end

  create_table "notepads", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.text "notepad_data"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_notepads_on_identity_id"
  end

  create_table "nutrients", force: :cascade do |t|
    t.string "nutrient_name"
    t.integer "measurement_type"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_nutrients_on_identity_id"
  end

  create_table "paid_tax_files", id: :serial, force: :cascade do |t|
    t.integer "paid_tax_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_paid_tax_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_paid_tax_files_on_identity_id"
    t.index ["paid_tax_id"], name: "index_paid_tax_files_on_paid_tax_id"
  end

  create_table "paid_taxes", id: :serial, force: :cascade do |t|
    t.date "paid_tax_date"
    t.decimal "donations", precision: 10, scale: 2
    t.decimal "federal_refund", precision: 10, scale: 2
    t.decimal "state_refund", precision: 10, scale: 2
    t.decimal "service_fee", precision: 10, scale: 2
    t.text "notes"
    t.integer "password_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "paid_tax_description"
    t.decimal "total_taxes_paid", precision: 10, scale: 2
    t.decimal "agi", precision: 10, scale: 2
    t.index ["identity_id"], name: "index_paid_taxes_on_identity_id"
    t.index ["password_id"], name: "index_paid_taxes_on_password_id"
  end

  create_table "pains", id: :serial, force: :cascade do |t|
    t.string "pain_location", limit: 255
    t.integer "intensity"
    t.datetime "pain_start_time"
    t.datetime "pain_end_time"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_pains_on_identity_id"
  end

  create_table "passport_pictures", id: :serial, force: :cascade do |t|
    t.integer "passport_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_passport_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_passport_pictures_on_identity_id"
    t.index ["passport_id"], name: "index_passport_pictures_on_passport_id"
  end

  create_table "passports", id: :serial, force: :cascade do |t|
    t.string "region", limit: 255
    t.string "passport_number", limit: 255
    t.date "expires"
    t.date "issued"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "issuing_authority", limit: 255
    t.string "name", limit: 255
    t.integer "visit_count"
    t.text "notes"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_passports_on_identity_id"
  end

  create_table "password_secret_shares", id: :serial, force: :cascade do |t|
    t.integer "password_secret_id"
    t.integer "password_share_id"
    t.integer "identity_id"
    t.string "unencrypted_answer"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_password_secret_shares_on_identity_id"
    t.index ["password_secret_id"], name: "index_password_secret_shares_on_password_secret_id"
    t.index ["password_share_id"], name: "index_password_secret_shares_on_password_share_id"
  end

  create_table "password_secrets", id: :serial, force: :cascade do |t|
    t.string "question", limit: 255
    t.string "answer", limit: 255
    t.integer "answer_encrypted_id"
    t.integer "password_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["answer_encrypted_id"], name: "index_password_secrets_on_answer_encrypted_id"
    t.index ["identity_id"], name: "index_password_secrets_on_identity_id"
    t.index ["password_id"], name: "index_password_secrets_on_password_id"
  end

  create_table "password_shares", id: :serial, force: :cascade do |t|
    t.integer "password_id"
    t.integer "user_id"
    t.integer "identity_id"
    t.string "unencrypted_password"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_password_shares_on_identity_id"
    t.index ["password_id"], name: "index_password_shares_on_password_id"
    t.index ["user_id"], name: "index_password_shares_on_user_id"
  end

  create_table "passwords", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.string "user", limit: 255
    t.string "password", limit: 255
    t.string "url", limit: 2000
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "password_encrypted_id"
    t.string "account_number", limit: 255
    t.datetime "archived"
    t.string "email", limit: 255
    t.integer "visit_count"
    t.integer "rating"
    t.index ["identity_id"], name: "index_passwords_on_identity_id"
    t.index ["password_encrypted_id"], name: "index_passwords_on_password_encrypted_id"
  end

  create_table "patent_files", id: :serial, force: :cascade do |t|
    t.integer "patent_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_patent_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_patent_files_on_identity_id"
    t.index ["patent_id"], name: "index_patent_files_on_patent_id"
  end

  create_table "patents", id: :serial, force: :cascade do |t|
    t.string "patent_name"
    t.string "patent_number"
    t.string "authors"
    t.string "region"
    t.date "filed_date"
    t.date "publication_date"
    t.text "patent_abstract"
    t.text "patent_text"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_patents_on_identity_id"
  end

  create_table "periodic_payment_instance_files", id: :serial, force: :cascade do |t|
    t.integer "periodic_payment_instance_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_periodic_payment_instance_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_periodic_payment_instance_files_on_identity_id"
    t.index ["periodic_payment_instance_id"], name: "ppif_on_ppi"
  end

  create_table "periodic_payment_instances", id: :serial, force: :cascade do |t|
    t.integer "periodic_payment_id"
    t.date "payment_date"
    t.decimal "amount", precision: 10, scale: 2
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_periodic_payment_instances_on_identity_id"
    t.index ["periodic_payment_id"], name: "index_periodic_payment_instances_on_periodic_payment_id"
  end

  create_table "periodic_payments", id: :serial, force: :cascade do |t|
    t.string "periodic_payment_name", limit: 255
    t.text "notes"
    t.date "started"
    t.date "ended"
    t.integer "date_period"
    t.decimal "payment_amount", precision: 10, scale: 2
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.boolean "suppress_reminder"
    t.integer "password_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_periodic_payments_on_identity_id"
    t.index ["password_id"], name: "index_periodic_payments_on_password_id"
  end

  create_table "perishable_foods", id: :serial, force: :cascade do |t|
    t.integer "food_id"
    t.date "purchased"
    t.date "expires"
    t.string "storage_location"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "quantity"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["food_id"], name: "index_perishable_foods_on_food_id"
    t.index ["identity_id"], name: "index_perishable_foods_on_identity_id"
  end

  create_table "permission_share_children", id: :serial, force: :cascade do |t|
    t.string "subject_class"
    t.integer "subject_id"
    t.integer "permission_share_id"
    t.integer "identity_id"
    t.integer "share_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_permission_share_children_on_identity_id"
    t.index ["permission_share_id"], name: "index_permission_share_children_on_permission_share_id"
    t.index ["share_id"], name: "index_permission_share_children_on_share_id"
  end

  create_table "permission_shares", id: :serial, force: :cascade do |t|
    t.string "subject_class"
    t.integer "subject_id"
    t.string "subject"
    t.text "body"
    t.boolean "copy_self"
    t.integer "share_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "email_id"
    t.string "child_selections"
    t.datetime "archived"
    t.integer "rating"
    t.string "valid_actions"
    t.index ["email_id"], name: "index_permission_shares_on_email_id"
    t.index ["identity_id"], name: "index_permission_shares_on_identity_id"
    t.index ["share_id"], name: "index_permission_shares_on_share_id"
  end

  create_table "permissions", id: :serial, force: :cascade do |t|
    t.integer "action"
    t.string "subject_class"
    t.integer "subject_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "user_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_permissions_on_identity_id"
    t.index ["user_id"], name: "index_permissions_on_user_id"
  end

  create_table "phone_files", id: :serial, force: :cascade do |t|
    t.integer "phone_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_phone_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_phone_files_on_identity_id"
    t.index ["phone_id"], name: "index_phone_files_on_phone_id"
  end

  create_table "phones", id: :serial, force: :cascade do |t|
    t.string "phone_model_name", limit: 255
    t.string "phone_number", limit: 255
    t.integer "manufacturer_id"
    t.date "purchased"
    t.decimal "price", precision: 10, scale: 2
    t.integer "operating_system"
    t.string "operating_system_version", limit: 255
    t.integer "max_resolution_width"
    t.integer "max_resolution_height"
    t.integer "ram"
    t.integer "num_cpus"
    t.integer "num_cores_per_cpu"
    t.boolean "hyperthreaded"
    t.decimal "max_cpu_speed", precision: 10, scale: 2
    t.boolean "cdma"
    t.boolean "gsm"
    t.decimal "front_camera_megapixels", precision: 10, scale: 2
    t.decimal "back_camera_megapixels", precision: 10, scale: 2
    t.text "notes"
    t.integer "identity_id"
    t.integer "password_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "dimensions_type"
    t.decimal "width", precision: 10, scale: 2
    t.decimal "height", precision: 10, scale: 2
    t.decimal "depth", precision: 10, scale: 2
    t.integer "weight_type"
    t.decimal "weight", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_phones_on_identity_id"
    t.index ["manufacturer_id"], name: "index_phones_on_manufacturer_id"
    t.index ["password_id"], name: "index_phones_on_password_id"
  end

  create_table "picnic_locations", force: :cascade do |t|
    t.bigint "location_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_picnic_locations_on_identity_id"
    t.index ["location_id"], name: "index_picnic_locations_on_location_id"
  end

  create_table "playlist_songs", id: :serial, force: :cascade do |t|
    t.integer "playlist_id"
    t.integer "song_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_playlist_songs_on_identity_id"
    t.index ["playlist_id"], name: "index_playlist_songs_on_playlist_id"
    t.index ["song_id"], name: "index_playlist_songs_on_song_id"
  end

  create_table "playlists", id: :serial, force: :cascade do |t|
    t.string "playlist_name", limit: 255
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_file_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_playlists_on_identity_file_id"
    t.index ["identity_id"], name: "index_playlists_on_identity_id"
  end

  create_table "podcasts", id: :serial, force: :cascade do |t|
    t.integer "feed_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["feed_id"], name: "index_podcasts_on_feed_id"
    t.index ["identity_id"], name: "index_podcasts_on_identity_id"
  end

  create_table "poems", id: :serial, force: :cascade do |t|
    t.string "poem_name", limit: 255
    t.text "poem"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.string "poem_author"
    t.string "poem_link"
    t.index ["identity_id"], name: "index_poems_on_identity_id"
  end

  create_table "point_displays", id: :serial, force: :cascade do |t|
    t.boolean "trash"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_point_displays_on_identity_id"
  end

  create_table "prescription_files", id: :serial, force: :cascade do |t|
    t.integer "prescription_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_prescription_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_prescription_files_on_identity_id"
    t.index ["prescription_id"], name: "index_prescription_files_on_prescription_id"
  end

  create_table "prescription_refills", id: :serial, force: :cascade do |t|
    t.integer "prescription_id"
    t.date "refill_date"
    t.integer "location_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_prescription_refills_on_identity_id"
    t.index ["location_id"], name: "index_prescription_refills_on_location_id"
    t.index ["prescription_id"], name: "index_prescription_refills_on_prescription_id"
  end

  create_table "prescriptions", id: :serial, force: :cascade do |t|
    t.string "prescription_name"
    t.date "prescription_date"
    t.text "notes"
    t.integer "doctor_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "refill_maximum"
    t.index ["doctor_id"], name: "index_prescriptions_on_doctor_id"
    t.index ["identity_id"], name: "index_prescriptions_on_identity_id"
  end

  create_table "problem_report_files", id: :serial, force: :cascade do |t|
    t.integer "problem_report_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_problem_report_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_problem_report_files_on_identity_id"
    t.index ["problem_report_id"], name: "index_problem_report_files_on_problem_report_id"
  end

  create_table "problem_reports", id: :serial, force: :cascade do |t|
    t.string "report_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_problem_reports_on_identity_id"
  end

  create_table "project_issue_files", id: :serial, force: :cascade do |t|
    t.integer "project_issue_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_project_issue_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_project_issue_files_on_identity_id"
    t.index ["project_issue_id"], name: "index_project_issue_files_on_project_issue_id"
  end

  create_table "project_issue_notifiers", id: :serial, force: :cascade do |t|
    t.integer "contact_id"
    t.integer "project_issue_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_project_issue_notifiers_on_contact_id"
    t.index ["identity_id"], name: "index_project_issue_notifiers_on_identity_id"
    t.index ["project_issue_id"], name: "index_project_issue_notifiers_on_project_issue_id"
  end

  create_table "project_issues", id: :serial, force: :cascade do |t|
    t.integer "project_id"
    t.integer "identity_id"
    t.integer "position"
    t.string "issue_name"
    t.text "notes"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_project_issues_on_identity_id"
    t.index ["project_id"], name: "index_project_issues_on_project_id"
  end

  create_table "projects", id: :serial, force: :cascade do |t|
    t.string "project_name"
    t.text "notes"
    t.date "start_date"
    t.date "end_date"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.boolean "default_to_top"
    t.index ["identity_id"], name: "index_projects_on_identity_id"
  end

  create_table "promises", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.date "due"
    t.text "promise"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_promises_on_identity_id"
  end

  create_table "promotions", id: :serial, force: :cascade do |t|
    t.string "promotion_name", limit: 255
    t.date "started"
    t.date "expires"
    t.decimal "promotion_amount", precision: 10, scale: 2
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_promotions_on_identity_id"
  end

  create_table "psychological_evaluation_files", id: :serial, force: :cascade do |t|
    t.integer "psychological_evaluation_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_psychological_evaluation_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_psychological_evaluation_files_on_identity_id"
    t.index ["psychological_evaluation_id"], name: "table_pef_on_pef_id"
  end

  create_table "psychological_evaluations", id: :serial, force: :cascade do |t|
    t.string "psychological_evaluation_name"
    t.date "evaluation_date"
    t.integer "evaluator_id"
    t.decimal "score", precision: 10, scale: 2
    t.text "evaluation"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["evaluator_id"], name: "index_psychological_evaluations_on_evaluator_id"
    t.index ["identity_id"], name: "index_psychological_evaluations_on_identity_id"
  end

  create_table "quest_files", id: :serial, force: :cascade do |t|
    t.integer "quest_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_quest_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_quest_files_on_identity_id"
    t.index ["quest_id"], name: "index_quest_files_on_quest_id"
  end

  create_table "questions", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_questions_on_identity_id"
  end

  create_table "quests", id: :serial, force: :cascade do |t|
    t.string "quest_title"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_quests_on_identity_id"
  end

  create_table "quotes", id: :serial, force: :cascade do |t|
    t.text "quote_text"
    t.date "quote_date"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "source"
    t.index ["identity_id"], name: "index_quotes_on_identity_id"
  end

  create_table "receipt_files", id: :serial, force: :cascade do |t|
    t.integer "receipt_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_receipt_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_receipt_files_on_identity_id"
    t.index ["receipt_id"], name: "index_receipt_files_on_receipt_id"
  end

  create_table "receipts", id: :serial, force: :cascade do |t|
    t.string "receipt_name"
    t.datetime "receipt_time"
    t.decimal "amount", precision: 10, scale: 2
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_receipts_on_identity_id"
  end

  create_table "recipe_pictures", id: :serial, force: :cascade do |t|
    t.integer "recipe_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_recipe_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_recipe_pictures_on_identity_id"
    t.index ["recipe_id"], name: "index_recipe_pictures_on_recipe_id"
  end

  create_table "recipes", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "recipe"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.string "recipe_category"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_recipes_on_identity_id"
  end

  create_table "recreational_vehicle_insurances", id: :serial, force: :cascade do |t|
    t.string "insurance_name", limit: 255
    t.integer "company_id"
    t.date "started"
    t.integer "periodic_payment_id"
    t.text "notes"
    t.integer "recreational_vehicle_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["company_id"], name: "index_recreational_vehicle_insurances_on_company_id"
    t.index ["identity_id"], name: "index_recreational_vehicle_insurances_on_identity_id"
    t.index ["periodic_payment_id"], name: "index_recreational_vehicle_insurances_on_periodic_payment_id"
  end

  create_table "recreational_vehicle_loans", id: :serial, force: :cascade do |t|
    t.integer "recreational_vehicle_id"
    t.integer "loan_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_recreational_vehicle_loans_on_identity_id"
    t.index ["loan_id"], name: "index_recreational_vehicle_loans_on_loan_id"
    t.index ["recreational_vehicle_id"], name: "index_recreational_vehicle_loans_on_recreational_vehicle_id"
  end

  create_table "recreational_vehicle_measurements", id: :serial, force: :cascade do |t|
    t.string "measurement_name", limit: 255
    t.integer "measurement_type"
    t.decimal "width", precision: 10, scale: 2
    t.decimal "height", precision: 10, scale: 2
    t.decimal "depth", precision: 10, scale: 2
    t.text "notes"
    t.integer "identity_id"
    t.integer "recreational_vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_recreational_vehicle_measurements_on_identity_id"
  end

  create_table "recreational_vehicle_pictures", id: :serial, force: :cascade do |t|
    t.integer "recreational_vehicle_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_recreational_vehicle_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_recreational_vehicle_pictures_on_identity_id"
    t.index ["recreational_vehicle_id"], name: "index_recreational_vehicle_pictures_on_recreational_vehicle_id"
  end

  create_table "recreational_vehicle_service_files", id: :serial, force: :cascade do |t|
    t.integer "recreational_vehicle_service_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_recreational_vehicle_service_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_recreational_vehicle_service_files_on_identity_id"
    t.index ["recreational_vehicle_service_id"], name: "index_rvservicefiles_rvserviceid"
  end

  create_table "recreational_vehicle_services", id: :serial, force: :cascade do |t|
    t.integer "recreational_vehicle_id"
    t.text "notes"
    t.string "short_description"
    t.date "date_due"
    t.date "date_serviced"
    t.string "service_location"
    t.decimal "cost", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_recreational_vehicle_services_on_identity_id"
    t.index ["recreational_vehicle_id"], name: "index_recreational_vehicle_services_on_recreational_vehicle_id"
  end

  create_table "recreational_vehicles", id: :serial, force: :cascade do |t|
    t.string "rv_name", limit: 255
    t.string "vin", limit: 255
    t.string "manufacturer", limit: 255
    t.string "model", limit: 255
    t.integer "year"
    t.decimal "price", precision: 10, scale: 2
    t.decimal "msrp", precision: 10, scale: 2
    t.date "purchased"
    t.date "owned_start"
    t.date "owned_end"
    t.text "notes"
    t.integer "location_purchased_id"
    t.integer "vehicle_id"
    t.decimal "wet_weight", precision: 10, scale: 2
    t.integer "sleeps"
    t.integer "dimensions_type"
    t.decimal "exterior_length", precision: 10, scale: 2
    t.decimal "exterior_width", precision: 10, scale: 2
    t.decimal "exterior_height", precision: 10, scale: 2
    t.decimal "exterior_height_over", precision: 10, scale: 2
    t.decimal "interior_height", precision: 10, scale: 2
    t.integer "liquid_capacity_type"
    t.integer "fresh_tank"
    t.integer "grey_tank"
    t.integer "black_tank"
    t.date "warranty_ends"
    t.integer "water_heater"
    t.integer "propane"
    t.integer "volume_type"
    t.integer "weight_type"
    t.integer "refrigerator"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal "exterior_length_over", precision: 10, scale: 2
    t.decimal "slideouts_extra_width", precision: 10, scale: 2
    t.decimal "floor_length", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_recreational_vehicles_on_identity_id"
    t.index ["location_purchased_id"], name: "index_recreational_vehicles_on_location_purchased_id"
    t.index ["vehicle_id"], name: "index_recreational_vehicles_on_vehicle_id"
  end

  create_table "regimen_items", force: :cascade do |t|
    t.bigint "regimen_id"
    t.string "regimen_item_name"
    t.integer "position"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_regimen_items_on_identity_id"
    t.index ["regimen_id"], name: "index_regimen_items_on_regimen_id"
  end

  create_table "regimens", force: :cascade do |t|
    t.string "regimen_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "regimen_type"
    t.index ["identity_id"], name: "index_regimens_on_identity_id"
  end

  create_table "repeats", id: :serial, force: :cascade do |t|
    t.date "start_date"
    t.integer "period_type"
    t.integer "period"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_repeats_on_identity_id"
  end

  create_table "restaurant_pictures", id: :serial, force: :cascade do |t|
    t.integer "restaurant_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_restaurant_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_restaurant_pictures_on_identity_id"
    t.index ["restaurant_id"], name: "index_restaurant_pictures_on_restaurant_id"
  end

  create_table "restaurants", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "rating"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.boolean "visited"
    t.datetime "archived"
    t.index ["identity_id"], name: "index_restaurants_on_identity_id"
    t.index ["location_id"], name: "index_restaurants_on_location_id"
  end

  create_table "retirement_plan_amount_files", id: :serial, force: :cascade do |t|
    t.integer "retirement_plan_amount_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_retirement_plan_amount_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_retirement_plan_amount_files_on_identity_id"
    t.index ["retirement_plan_amount_id"], name: "index_retirement_plan_amount_files_on_retirement_plan_amount_id"
  end

  create_table "retirement_plan_amounts", id: :serial, force: :cascade do |t|
    t.integer "retirement_plan_id"
    t.date "input_date"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "identity_id"
    t.text "notes"
    t.datetime "archived"
    t.integer "rating"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_retirement_plan_amounts_on_identity_id"
    t.index ["retirement_plan_id"], name: "index_retirement_plan_amounts_on_retirement_plan_id"
  end

  create_table "retirement_plans", id: :serial, force: :cascade do |t|
    t.string "retirement_plan_name"
    t.integer "retirement_plan_type"
    t.integer "company_id"
    t.integer "periodic_payment_id"
    t.date "started"
    t.text "notes"
    t.integer "password_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["company_id"], name: "index_retirement_plans_on_company_id"
    t.index ["identity_id"], name: "index_retirement_plans_on_identity_id"
    t.index ["password_id"], name: "index_retirement_plans_on_password_id"
    t.index ["periodic_payment_id"], name: "index_retirement_plans_on_periodic_payment_id"
  end

  create_table "reward_program_files", id: :serial, force: :cascade do |t|
    t.integer "reward_program_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_reward_program_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_reward_program_files_on_identity_id"
    t.index ["reward_program_id"], name: "index_reward_program_files_on_reward_program_id"
  end

  create_table "reward_programs", id: :serial, force: :cascade do |t|
    t.string "reward_program_name", limit: 255
    t.date "started"
    t.date "ended"
    t.string "reward_program_number", limit: 255
    t.string "reward_program_status", limit: 255
    t.text "notes"
    t.integer "password_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "program_type"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_reward_programs_on_identity_id"
    t.index ["password_id"], name: "index_reward_programs_on_password_id"
  end

  create_table "settings", force: :cascade do |t|
    t.string "setting_name"
    t.string "setting_value"
    t.bigint "category_id"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["category_id"], name: "index_settings_on_category_id"
    t.index ["identity_id"], name: "index_settings_on_identity_id"
  end

  create_table "shares", id: :serial, force: :cascade do |t|
    t.string "token", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "use_count"
    t.integer "max_use_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_shares_on_identity_id"
  end

  create_table "shopping_list_items", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "shopping_list_id"
    t.string "shopping_list_item_name", limit: 255
    t.integer "position"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_shopping_list_items_on_identity_id"
    t.index ["shopping_list_id"], name: "index_shopping_list_items_on_shopping_list_id"
  end

  create_table "shopping_lists", id: :serial, force: :cascade do |t|
    t.string "shopping_list_name", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_shopping_lists_on_identity_id"
  end

  create_table "sickness_files", force: :cascade do |t|
    t.bigint "sickness_id"
    t.bigint "identity_file_id"
    t.bigint "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_sickness_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_sickness_files_on_identity_id"
    t.index ["sickness_id"], name: "index_sickness_files_on_sickness_id"
  end

  create_table "sicknesses", force: :cascade do |t|
    t.date "sickness_start"
    t.date "sickness_end"
    t.boolean "coughing"
    t.boolean "sneezing"
    t.boolean "throwing_up"
    t.boolean "fever"
    t.boolean "runny_nose"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_sicknesses_on_identity_id"
  end

  create_table "site_contacts", id: :serial, force: :cascade do |t|
    t.string "name"
    t.string "email"
    t.string "subject"
    t.text "body"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "skin_treatments", id: :serial, force: :cascade do |t|
    t.datetime "treatment_time"
    t.string "treatment_activity", limit: 255
    t.string "treatment_location", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_skin_treatments_on_identity_id"
  end

  create_table "sleep_measurements", id: :serial, force: :cascade do |t|
    t.datetime "sleep_start_time"
    t.datetime "sleep_end_time"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_sleep_measurements_on_identity_id"
  end

  create_table "snoozed_due_items", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.string "display", limit: 255
    t.string "link", limit: 255
    t.datetime "due_date"
    t.datetime "original_due_date"
    t.string "myp_model_name", limit: 255
    t.integer "model_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "calendar_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["calendar_id"], name: "index_snoozed_due_items_on_calendar_id"
    t.index ["identity_id"], name: "index_snoozed_due_items_on_identity_id"
  end

  create_table "software_license_files", id: :serial, force: :cascade do |t|
    t.integer "software_license_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_software_license_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_software_license_files_on_identity_id"
    t.index ["software_license_id"], name: "index_software_license_files_on_software_license_id"
  end

  create_table "software_licenses", id: :serial, force: :cascade do |t|
    t.string "license_name"
    t.decimal "license_value", precision: 10, scale: 2
    t.date "license_purchase_date"
    t.text "license_key"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_software_licenses_on_identity_id"
  end

  create_table "songs", id: :serial, force: :cascade do |t|
    t.string "song_name", limit: 255
    t.decimal "song_rating", precision: 10, scale: 2
    t.text "lyrics"
    t.integer "song_plays"
    t.datetime "lastplay"
    t.boolean "secret"
    t.boolean "awesome"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.integer "identity_file_id"
    t.integer "musical_group_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_songs_on_identity_file_id"
    t.index ["identity_id"], name: "index_songs_on_identity_id"
    t.index ["musical_group_id"], name: "index_songs_on_musical_group_id"
  end

  create_table "ssh_keys", id: :serial, force: :cascade do |t|
    t.string "ssh_key_name"
    t.text "ssh_private_key"
    t.text "ssh_public_key"
    t.integer "password_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "ssh_private_key_encrypted_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_ssh_keys_on_identity_id"
    t.index ["password_id"], name: "index_ssh_keys_on_password_id"
    t.index ["ssh_private_key_encrypted_id"], name: "index_ssh_keys_on_ssh_private_key_encrypted_id"
  end

  create_table "statuses", id: :serial, force: :cascade do |t|
    t.datetime "status_time"
    t.text "three_good_things"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "feeling"
    t.integer "visit_count"
    t.string "status1", limit: 255
    t.string "status2", limit: 255
    t.string "status3", limit: 255
    t.datetime "archived"
    t.integer "rating"
    t.string "stoic_ailments"
    t.string "stoic_failings"
    t.string "stoic_failed"
    t.string "stoic_duties"
    t.string "stoic_improvement"
    t.string "stoic_faults"
    t.index ["identity_id"], name: "index_statuses_on_identity_id"
  end

  create_table "stocks", id: :serial, force: :cascade do |t|
    t.integer "company_id"
    t.integer "num_shares"
    t.text "notes"
    t.date "vest_date"
    t.integer "password_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["company_id"], name: "index_stocks_on_company_id"
    t.index ["identity_id"], name: "index_stocks_on_identity_id"
    t.index ["password_id"], name: "index_stocks_on_password_id"
  end

  create_table "stories", id: :serial, force: :cascade do |t|
    t.string "story_name"
    t.text "story"
    t.datetime "story_time"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_stories_on_identity_id"
  end

  create_table "story_pictures", id: :serial, force: :cascade do |t|
    t.integer "story_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_story_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_story_pictures_on_identity_id"
    t.index ["story_id"], name: "index_story_pictures_on_story_id"
  end

  create_table "sun_exposures", id: :serial, force: :cascade do |t|
    t.datetime "exposure_start"
    t.datetime "exposure_end"
    t.string "uncovered_body_parts", limit: 255
    t.string "sunscreened_body_parts", limit: 255
    t.string "sunscreen_type", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_sun_exposures_on_identity_id"
  end

  create_table "surgeries", id: :serial, force: :cascade do |t|
    t.string "surgery_name"
    t.date "surgery_date"
    t.integer "hospital_id"
    t.integer "doctor_id"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["doctor_id"], name: "index_surgeries_on_doctor_id"
    t.index ["hospital_id"], name: "index_surgeries_on_hospital_id"
    t.index ["identity_id"], name: "index_surgeries_on_identity_id"
  end

  create_table "surgery_files", id: :serial, force: :cascade do |t|
    t.integer "surgery_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_surgery_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_surgery_files_on_identity_id"
    t.index ["surgery_id"], name: "index_surgery_files_on_surgery_id"
  end

  create_table "tax_document_files", id: :serial, force: :cascade do |t|
    t.integer "tax_document_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_tax_document_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_tax_document_files_on_identity_id"
    t.index ["tax_document_id"], name: "index_tax_document_files_on_tax_document_id"
  end

  create_table "tax_documents", id: :serial, force: :cascade do |t|
    t.string "tax_document_form_name"
    t.string "tax_document_description"
    t.text "notes"
    t.date "received_date"
    t.integer "fiscal_year"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_tax_documents_on_identity_id"
  end

  create_table "temperatures", id: :serial, force: :cascade do |t|
    t.datetime "measured"
    t.decimal "measured_temperature", precision: 10, scale: 2
    t.string "measurement_source", limit: 255
    t.integer "temperature_type"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_temperatures_on_identity_id"
  end

  create_table "test_object_files", id: :serial, force: :cascade do |t|
    t.integer "test_object_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_test_object_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_test_object_files_on_identity_id"
    t.index ["test_object_id"], name: "index_test_object_files_on_test_object_id"
  end

  create_table "test_object_instance_files", id: :serial, force: :cascade do |t|
    t.integer "test_object_instance_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_test_object_instance_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_test_object_instance_files_on_identity_id"
    t.index ["test_object_instance_id"], name: "index_test_object_instance_files_on_test_object_instance_id"
  end

  create_table "test_object_instances", id: :serial, force: :cascade do |t|
    t.integer "test_object_id"
    t.string "test_object_instance_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_test_object_instances_on_identity_id"
    t.index ["test_object_id"], name: "index_test_object_instances_on_test_object_id"
  end

  create_table "test_objects", id: :serial, force: :cascade do |t|
    t.string "test_object_name"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "contact_id"
    t.string "test_object_string"
    t.date "test_object_date"
    t.datetime "test_object_datetime"
    t.time "test_object_time"
    t.integer "test_object_number"
    t.decimal "test_object_decimal", precision: 10, scale: 2
    t.decimal "test_object_currency", precision: 10, scale: 2
    t.boolean "test_object_boolean"
    t.integer "test_object_enum"
    t.index ["contact_id"], name: "index_test_objects_on_contact_id"
    t.index ["identity_id"], name: "index_test_objects_on_identity_id"
  end

  create_table "test_score_files", id: :serial, force: :cascade do |t|
    t.integer "test_score_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_test_score_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_test_score_files_on_identity_id"
    t.index ["test_score_id"], name: "index_test_score_files_on_test_score_id"
  end

  create_table "test_scores", id: :serial, force: :cascade do |t|
    t.string "test_score_name"
    t.date "test_score_date"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.decimal "test_score", precision: 10, scale: 2
    t.index ["identity_id"], name: "index_test_scores_on_identity_id"
  end

  create_table "text_message_contacts", id: :serial, force: :cascade do |t|
    t.integer "text_message_id"
    t.integer "contact_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_text_message_contacts_on_contact_id"
    t.index ["identity_id"], name: "index_text_message_contacts_on_identity_id"
    t.index ["text_message_id"], name: "index_text_message_contacts_on_text_message_id"
  end

  create_table "text_message_groups", id: :serial, force: :cascade do |t|
    t.integer "text_message_id"
    t.integer "group_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["group_id"], name: "index_text_message_groups_on_group_id"
    t.index ["identity_id"], name: "index_text_message_groups_on_identity_id"
    t.index ["text_message_id"], name: "index_text_message_groups_on_text_message_id"
  end

  create_table "text_message_tokens", force: :cascade do |t|
    t.string "phone_number"
    t.string "token"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_text_message_tokens_on_identity_id"
  end

  create_table "text_message_unsubscriptions", id: :serial, force: :cascade do |t|
    t.string "phone_number"
    t.string "category"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_text_message_unsubscriptions_on_identity_id"
  end

  create_table "text_messages", id: :serial, force: :cascade do |t|
    t.text "body"
    t.boolean "copy_self"
    t.string "message_category"
    t.boolean "draft"
    t.boolean "personalize"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.text "long_body"
    t.index ["identity_id"], name: "index_text_messages_on_identity_id"
  end

  create_table "therapists", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "contact_id"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["contact_id"], name: "index_therapists_on_contact_id"
    t.index ["identity_id"], name: "index_therapists_on_identity_id"
  end

  create_table "timing_events", id: :serial, force: :cascade do |t|
    t.integer "timing_id"
    t.datetime "timing_event_start"
    t.datetime "timing_event_end"
    t.text "notes"
    t.integer "identity_id"
    t.integer "visit_count"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_timing_events_on_identity_id"
    t.index ["timing_id"], name: "index_timing_events_on_timing_id"
  end

  create_table "timings", id: :serial, force: :cascade do |t|
    t.string "timing_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_timings_on_identity_id"
  end

  create_table "to_dos", id: :serial, force: :cascade do |t|
    t.string "short_description", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "due_time"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_to_dos_on_identity_id"
  end

  create_table "trek_pictures", id: :serial, force: :cascade do |t|
    t.integer "trek_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_trek_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_trek_pictures_on_identity_id"
    t.index ["trek_id"], name: "index_trek_pictures_on_trek_id"
  end

  create_table "treks", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.integer "rating"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.index ["identity_id"], name: "index_treks_on_identity_id"
    t.index ["location_id"], name: "index_treks_on_location_id"
  end

  create_table "trip_flights", id: :serial, force: :cascade do |t|
    t.integer "trip_id"
    t.integer "flight_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["flight_id"], name: "index_trip_flights_on_flight_id"
    t.index ["identity_id"], name: "index_trip_flights_on_identity_id"
    t.index ["trip_id"], name: "index_trip_flights_on_trip_id"
  end

  create_table "trip_pictures", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "trip_id"
    t.integer "identity_file_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "position"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_trip_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_trip_pictures_on_identity_id"
    t.index ["trip_id"], name: "index_trip_pictures_on_trip_id"
  end

  create_table "trip_stories", id: :serial, force: :cascade do |t|
    t.integer "trip_id"
    t.integer "story_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_trip_stories_on_identity_id"
    t.index ["story_id"], name: "index_trip_stories_on_story_id"
    t.index ["trip_id"], name: "index_trip_stories_on_trip_id"
  end

  create_table "trips", id: :serial, force: :cascade do |t|
    t.integer "location_id"
    t.date "started"
    t.date "ended"
    t.text "notes"
    t.boolean "work"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.integer "hotel_id"
    t.integer "identity_file_id"
    t.boolean "notify_emergency_contacts"
    t.boolean "explicitly_completed"
    t.datetime "archived"
    t.integer "rating"
    t.string "trip_name"
    t.index ["hotel_id"], name: "index_trips_on_hotel_id"
    t.index ["identity_file_id"], name: "index_trips_on_identity_file_id"
    t.index ["identity_id"], name: "index_trips_on_identity_id"
    t.index ["location_id"], name: "index_trips_on_location_id"
  end

  create_table "tv_shows", id: :serial, force: :cascade do |t|
    t.string "tv_show_name"
    t.text "notes"
    t.datetime "watched"
    t.string "url"
    t.integer "recommender_id"
    t.string "tv_genre"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_tv_shows_on_identity_id"
    t.index ["recommender_id"], name: "index_tv_shows_on_recommender_id"
  end

  create_table "us_zip_codes", id: :serial, force: :cascade do |t|
    t.string "zip_code"
    t.string "city"
    t.string "state"
    t.string "county"
    t.decimal "latitude", precision: 12, scale: 8
    t.decimal "longitude", precision: 12, scale: 8
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "usda_food_groups", id: false, force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_usda_food_groups_on_code", unique: true
  end

  create_table "usda_foods", id: false, force: :cascade do |t|
    t.string "nutrient_databank_number", null: false
    t.string "food_group_code"
    t.string "long_description", null: false
    t.string "short_description", null: false
    t.string "common_names"
    t.string "manufacturer_name"
    t.boolean "survey"
    t.string "refuse_description"
    t.integer "percentage_refuse"
    t.float "nitrogen_factor"
    t.float "protein_factor"
    t.float "fat_factor"
    t.float "carbohydrate_factor"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["food_group_code"], name: "index_usda_foods_on_food_group_code"
    t.index ["nutrient_databank_number"], name: "index_usda_foods_on_nutrient_databank_number", unique: true
  end

  create_table "usda_foods_nutrients", id: false, force: :cascade do |t|
    t.string "nutrient_databank_number", null: false
    t.string "nutrient_number", null: false
    t.float "nutrient_value", null: false
    t.integer "num_data_points", null: false
    t.float "standard_error"
    t.string "src_code", null: false
    t.string "derivation_code"
    t.string "ref_nutrient_databank_number"
    t.boolean "add_nutrient_mark"
    t.integer "num_studies"
    t.float "min"
    t.float "max"
    t.integer "degrees_of_freedom"
    t.float "lower_error_bound"
    t.float "upper_error_bound"
    t.string "statistical_comments"
    t.string "add_mod_date"
    t.string "confidence_code"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nutrient_databank_number", "nutrient_number"], name: "foods_nutrients_index"
    t.index ["nutrient_databank_number", "nutrient_number"], name: "index_usda_foods_nutrients_on_databank_number_and_number", unique: true
  end

  create_table "usda_footnotes", force: :cascade do |t|
    t.string "nutrient_databank_number", null: false
    t.string "footnote_number", null: false
    t.string "footnote_type", null: false
    t.string "nutrient_number"
    t.string "footnote_text", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nutrient_databank_number", "footnote_type"], name: "index_usda_footnotes_on_databank_number_and_type"
    t.index ["nutrient_databank_number", "nutrient_number", "footnote_number"], name: "index_usda_footnotes_on_unique_keys", unique: true
  end

  create_table "usda_nutrients", id: false, force: :cascade do |t|
    t.string "nutrient_number", null: false
    t.string "units", null: false
    t.string "tagname"
    t.string "nutrient_description", null: false
    t.string "number_decimal_places", null: false
    t.integer "sort_record_order", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nutrient_number"], name: "index_usda_nutrients_on_nutrient_number", unique: true
  end

  create_table "usda_source_codes", force: :cascade do |t|
    t.string "code", null: false
    t.string "description", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["code"], name: "index_usda_source_codes_on_code", unique: true
  end

  create_table "usda_weights", id: false, force: :cascade do |t|
    t.string "nutrient_databank_number", null: false
    t.string "sequence_number", null: false
    t.float "amount", null: false
    t.string "measurement_description", null: false
    t.float "gram_weight", null: false
    t.integer "num_data_points"
    t.float "standard_deviation"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["nutrient_databank_number", "sequence_number"], name: "uw_for_ndn_sn", unique: true
  end

  create_table "user_capabilities", force: :cascade do |t|
    t.integer "capability"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_user_capabilities_on_identity_id"
  end

  create_table "users", id: :serial, force: :cascade do |t|
    t.string "email", limit: 255, default: "", null: false
    t.string "encrypted_password", limit: 255, default: "", null: false
    t.string "reset_password_token", limit: 255
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer "sign_in_count", default: 0, null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet "current_sign_in_ip"
    t.inet "last_sign_in_ip"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "primary_identity_id"
    t.string "confirmation_token", limit: 255
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.integer "failed_attempts", default: 0
    t.string "unlock_token", limit: 255
    t.datetime "locked_at"
    t.string "unconfirmed_email", limit: 255
    t.boolean "encrypt_by_default", default: false
    t.string "timezone", limit: 255
    t.integer "page_transition"
    t.integer "clipboard_integration"
    t.boolean "explicit_categories"
    t.integer "user_type"
    t.boolean "clipboard_transform_numbers"
    t.integer "visit_count"
    t.boolean "enable_sounds"
    t.boolean "always_autofocus"
    t.boolean "experimental_categories"
    t.integer "items_per_page"
    t.boolean "show_timestamps"
    t.boolean "always_enable_debug"
    t.integer "top_left_icon"
    t.integer "recently_visited_categories"
    t.integer "most_visited_categories"
    t.integer "most_visited_items"
    t.boolean "minimize_password_checks"
    t.integer "suppressions"
    t.boolean "show_server_name"
    t.integer "after_new_item"
    t.boolean "allow_adding_existing_file"
    t.boolean "pending_encryption_switch"
    t.integer "encryption_mode"
    t.boolean "non_fixed_header"
    t.boolean "toggle_hide_footer"
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true
    t.index ["unlock_token"], name: "index_users_on_unlock_token", unique: true
  end

  create_table "vaccine_files", id: :serial, force: :cascade do |t|
    t.integer "vaccine_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_vaccine_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_vaccine_files_on_identity_id"
    t.index ["vaccine_id"], name: "index_vaccine_files_on_vaccine_id"
  end

  create_table "vaccines", id: :serial, force: :cascade do |t|
    t.string "vaccine_name"
    t.date "vaccine_date"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_vaccines_on_identity_id"
  end

  create_table "vehicle_insurances", id: :serial, force: :cascade do |t|
    t.string "insurance_name", limit: 255
    t.integer "company_id"
    t.date "started"
    t.integer "periodic_payment_id"
    t.integer "vehicle_id"
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["company_id"], name: "index_vehicle_insurances_on_company_id"
    t.index ["identity_id"], name: "index_vehicle_insurances_on_identity_id"
    t.index ["periodic_payment_id"], name: "index_vehicle_insurances_on_periodic_payment_id"
    t.index ["vehicle_id"], name: "index_vehicle_insurances_on_vehicle_id"
  end

  create_table "vehicle_loans", id: :serial, force: :cascade do |t|
    t.integer "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "loan_id"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_vehicle_loans_on_identity_id"
    t.index ["vehicle_id"], name: "index_vehicle_loans_on_vehicle_id"
  end

  create_table "vehicle_pictures", id: :serial, force: :cascade do |t|
    t.integer "vehicle_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.integer "position"
    t.index ["identity_file_id"], name: "index_vehicle_pictures_on_identity_file_id"
    t.index ["identity_id"], name: "index_vehicle_pictures_on_identity_id"
    t.index ["vehicle_id"], name: "index_vehicle_pictures_on_vehicle_id"
  end

  create_table "vehicle_registration_files", id: :serial, force: :cascade do |t|
    t.integer "vehicle_registration_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_vehicle_registration_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_vehicle_registration_files_on_identity_id"
    t.index ["vehicle_registration_id"], name: "index_vehicle_registration_files_on_vehicle_registration_id"
  end

  create_table "vehicle_registrations", id: :serial, force: :cascade do |t|
    t.integer "vehicle_id"
    t.string "registration_source"
    t.date "registration_date"
    t.decimal "amount", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_vehicle_registrations_on_identity_id"
    t.index ["vehicle_id"], name: "index_vehicle_registrations_on_vehicle_id"
  end

  create_table "vehicle_service_files", id: :serial, force: :cascade do |t|
    t.integer "vehicle_service_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_file_id"], name: "index_vehicle_service_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_vehicle_service_files_on_identity_id"
    t.index ["vehicle_service_id"], name: "index_vehicle_service_files_on_vehicle_service_id"
  end

  create_table "vehicle_services", id: :serial, force: :cascade do |t|
    t.integer "vehicle_id"
    t.text "notes"
    t.string "short_description", limit: 255
    t.date "date_due"
    t.date "date_serviced"
    t.text "service_location"
    t.decimal "cost", precision: 10, scale: 2
    t.integer "miles"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "identity_id"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_vehicle_services_on_identity_id"
    t.index ["vehicle_id"], name: "index_vehicle_services_on_vehicle_id"
  end

  create_table "vehicle_warranties", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "warranty_id"
    t.integer "vehicle_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_vehicle_warranties_on_identity_id"
    t.index ["vehicle_id"], name: "index_vehicle_warranties_on_vehicle_id"
    t.index ["warranty_id"], name: "index_vehicle_warranties_on_warranty_id"
  end

  create_table "vehicles", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "notes"
    t.date "owned_start"
    t.date "owned_end"
    t.string "vin", limit: 255
    t.string "manufacturer", limit: 255
    t.string "model", limit: 255
    t.integer "year"
    t.string "color", limit: 255
    t.string "license_plate", limit: 255
    t.string "region", limit: 255
    t.string "sub_region1", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string "trim_name", limit: 255
    t.integer "dimensions_type"
    t.decimal "height", precision: 10, scale: 2
    t.decimal "width", precision: 10, scale: 2
    t.decimal "length", precision: 10, scale: 2
    t.decimal "wheel_base", precision: 10, scale: 2
    t.decimal "ground_clearance", precision: 10, scale: 2
    t.integer "weight_type"
    t.integer "doors_type"
    t.integer "passenger_seats"
    t.decimal "gvwr", precision: 10, scale: 2
    t.decimal "gcwr", precision: 10, scale: 2
    t.decimal "gawr_front", precision: 10, scale: 2
    t.decimal "gawr_rear", precision: 10, scale: 2
    t.string "front_axle_details", limit: 255
    t.decimal "front_axle_rating", precision: 10, scale: 2
    t.string "front_suspension_details", limit: 255
    t.decimal "front_suspension_rating", precision: 10, scale: 2
    t.string "rear_axle_details", limit: 255
    t.decimal "rear_axle_rating", precision: 10, scale: 2
    t.string "rear_suspension_details", limit: 255
    t.decimal "rear_suspension_rating", precision: 10, scale: 2
    t.string "tire_details", limit: 255
    t.decimal "tire_rating", precision: 10, scale: 2
    t.decimal "tire_diameter", precision: 10, scale: 2
    t.string "wheel_details", limit: 255
    t.decimal "wheel_rating", precision: 10, scale: 2
    t.integer "engine_type"
    t.integer "wheel_drive_type"
    t.integer "wheels_type"
    t.integer "fuel_tank_capacity_type"
    t.decimal "fuel_tank_capacity", precision: 10, scale: 2
    t.decimal "wet_weight_front", precision: 10, scale: 2
    t.decimal "wet_weight_rear", precision: 10, scale: 2
    t.decimal "tailgate_weight", precision: 10, scale: 2
    t.integer "horsepower"
    t.integer "cylinders"
    t.integer "displacement_type"
    t.integer "doors"
    t.decimal "displacement", precision: 10, scale: 2
    t.decimal "bed_length", precision: 10, scale: 2
    t.integer "recreational_vehicle_id"
    t.decimal "price", precision: 10, scale: 2
    t.decimal "msrp", precision: 10, scale: 2
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.decimal "bought_miles", precision: 10, scale: 2
    t.index ["identity_id"], name: "index_vehicles_on_identity_id"
  end

  create_table "vitamin_ingredients", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.integer "parent_vitamin_id"
    t.integer "vitamin_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_vitamin_ingredients_on_identity_id"
    t.index ["parent_vitamin_id"], name: "index_vitamin_ingredients_on_parent_vitamin_id"
    t.index ["vitamin_id"], name: "index_vitamin_ingredients_on_vitamin_id"
  end

  create_table "vitamins", id: :serial, force: :cascade do |t|
    t.integer "identity_id"
    t.string "vitamin_name", limit: 255
    t.text "notes"
    t.decimal "vitamin_amount", precision: 10, scale: 2
    t.integer "amount_type"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_vitamins_on_identity_id"
  end

  create_table "volunteering_activities", id: :serial, force: :cascade do |t|
    t.string "volunteering_activity_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_volunteering_activities_on_identity_id"
  end

  create_table "warranties", id: :serial, force: :cascade do |t|
    t.string "warranty_name", limit: 255
    t.date "warranty_start"
    t.date "warranty_end"
    t.string "warranty_condition", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_warranties_on_identity_id"
  end

  create_table "web_comics", id: :serial, force: :cascade do |t|
    t.string "web_comic_name"
    t.integer "website_id"
    t.integer "feed_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["feed_id"], name: "index_web_comics_on_feed_id"
    t.index ["identity_id"], name: "index_web_comics_on_identity_id"
    t.index ["website_id"], name: "index_web_comics_on_website_id"
  end

  create_table "website_domain_registrations", id: :serial, force: :cascade do |t|
    t.integer "website_domain_id"
    t.integer "repeat_id"
    t.integer "periodic_payment_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_website_domain_registrations_on_identity_id"
    t.index ["periodic_payment_id"], name: "index_website_domain_registrations_on_periodic_payment_id"
    t.index ["repeat_id"], name: "index_website_domain_registrations_on_repeat_id"
    t.index ["website_domain_id"], name: "index_website_domain_registrations_on_website_domain_id"
  end

  create_table "website_domain_ssh_keys", id: :serial, force: :cascade do |t|
    t.integer "website_domain_id"
    t.integer "identity_id"
    t.integer "ssh_key_id"
    t.string "username"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_website_domain_ssh_keys_on_identity_id"
    t.index ["ssh_key_id"], name: "index_website_domain_ssh_keys_on_ssh_key_id"
    t.index ["website_domain_id"], name: "index_website_domain_ssh_keys_on_website_domain_id"
  end

  create_table "website_domains", id: :serial, force: :cascade do |t|
    t.string "domain_name"
    t.text "notes"
    t.integer "domain_host_id"
    t.integer "website_id"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.boolean "verified"
    t.boolean "default_domain"
    t.string "meta_description"
    t.string "meta_keywords"
    t.string "hosts"
    t.text "static_homepage"
    t.text "menu_links_static"
    t.text "menu_links_logged_in"
    t.bigint "favicon_ico_identity_file_id"
    t.bigint "favicon_png_identity_file_id"
    t.bigint "default_header_icon_identity_file_id"
    t.text "new_user_welcome"
    t.text "about"
    t.text "mission_statement"
    t.text "faq"
    t.index ["default_header_icon_identity_file_id"], name: "index_website_domains_on_default_header_icon_identity_file_id"
    t.index ["domain_host_id"], name: "index_website_domains_on_domain_host_id"
    t.index ["favicon_ico_identity_file_id"], name: "index_website_domains_on_favicon_ico_identity_file_id"
    t.index ["favicon_png_identity_file_id"], name: "index_website_domains_on_favicon_png_identity_file_id"
    t.index ["identity_id"], name: "index_website_domains_on_identity_id"
    t.index ["website_id"], name: "index_website_domains_on_website_id"
  end

  create_table "website_list_items", id: :serial, force: :cascade do |t|
    t.integer "website_list_id"
    t.integer "website_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_website_list_items_on_identity_id"
    t.index ["website_id"], name: "index_website_list_items_on_website_id"
    t.index ["website_list_id"], name: "index_website_list_items_on_website_list_id"
  end

  create_table "website_lists", id: :serial, force: :cascade do |t|
    t.string "website_list_name"
    t.text "notes"
    t.integer "visit_count"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.boolean "disable_autoload"
    t.integer "iframe_height"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_website_lists_on_identity_id"
  end

  create_table "website_passwords", id: :serial, force: :cascade do |t|
    t.integer "website_id"
    t.integer "password_id"
    t.integer "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_website_passwords_on_identity_id"
    t.index ["password_id"], name: "index_website_passwords_on_password_id"
    t.index ["website_id"], name: "index_website_passwords_on_website_id"
  end

  create_table "website_scraper_transformations", force: :cascade do |t|
    t.integer "transformation_type"
    t.text "transformation"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.integer "position"
    t.bigint "website_scraper_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["identity_id"], name: "index_website_scraper_transformations_on_identity_id"
    t.index ["website_scraper_id"], name: "index_website_scraper_transformations_on_website_scraper_id"
  end

  create_table "website_scrapers", force: :cascade do |t|
    t.string "scraper_name"
    t.string "website_url"
    t.text "notes"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.bigint "identity_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "content_type"
    t.index ["identity_id"], name: "index_website_scrapers_on_identity_id"
  end

  create_table "websites", id: :serial, force: :cascade do |t|
    t.string "title", limit: 255
    t.string "url", limit: 2000
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.boolean "to_visit"
    t.integer "recommender_id"
    t.text "notes"
    t.string "website_category"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_websites_on_identity_id"
    t.index ["recommender_id"], name: "index_websites_on_recommender_id"
  end

  create_table "weights", id: :serial, force: :cascade do |t|
    t.decimal "amount", precision: 10, scale: 2
    t.integer "amount_type"
    t.date "measure_date"
    t.string "source", limit: 255
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_weights_on_identity_id"
  end

  create_table "wisdom_files", id: :serial, force: :cascade do |t|
    t.integer "wisdom_id"
    t.integer "identity_file_id"
    t.integer "identity_id"
    t.integer "position"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_file_id"], name: "index_wisdom_files_on_identity_file_id"
    t.index ["identity_id"], name: "index_wisdom_files_on_identity_id"
    t.index ["wisdom_id"], name: "index_wisdom_files_on_wisdom_id"
  end

  create_table "wisdoms", id: :serial, force: :cascade do |t|
    t.string "name", limit: 255
    t.text "notes"
    t.integer "identity_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.integer "visit_count"
    t.datetime "archived"
    t.integer "rating"
    t.index ["identity_id"], name: "index_wisdoms_on_identity_id"
  end

  add_foreign_key "accomplishments", "identities", name: "accomplishments_identity_id_fk"
  add_foreign_key "acne_measurement_pictures", "acne_measurements", name: "acne_measurement_pictures_acne_measurement_id_fk"
  add_foreign_key "acne_measurement_pictures", "identities", name: "acne_measurement_pictures_identity_id_fk"
  add_foreign_key "acne_measurement_pictures", "identity_files", name: "acne_measurement_pictures_identity_file_id_fk"
  add_foreign_key "acne_measurements", "identities", name: "acne_measurements_identity_id_fk"
  add_foreign_key "activities", "identities", name: "activities_identity_id_fk"
  add_foreign_key "admin_emails", "emails"
  add_foreign_key "admin_emails", "identities"
  add_foreign_key "admin_text_messages", "identities"
  add_foreign_key "admin_text_messages", "text_messages"
  add_foreign_key "alerts_displays", "identities"
  add_foreign_key "annuities", "identities"
  add_foreign_key "apartment_lease_files", "apartment_leases"
  add_foreign_key "apartment_lease_files", "identities"
  add_foreign_key "apartment_lease_files", "identity_files"
  add_foreign_key "apartment_leases", "apartments", name: "apartment_leases_apartment_id_fk"
  add_foreign_key "apartment_leases", "identities", name: "apartment_leases_identity_id_fk"
  add_foreign_key "apartment_pictures", "apartments", name: "apartment_pictures_apartment_id_fk"
  add_foreign_key "apartment_pictures", "identities", name: "apartment_pictures_identity_id_fk"
  add_foreign_key "apartment_pictures", "identity_files", name: "apartment_pictures_identity_file_id_fk"
  add_foreign_key "apartment_trash_pickups", "apartments", name: "apartment_trash_pickups_apartment_id_fk"
  add_foreign_key "apartment_trash_pickups", "identities", name: "apartment_trash_pickups_identity_id_fk"
  add_foreign_key "apartment_trash_pickups", "repeats", name: "apartment_trash_pickups_repeat_id_fk"
  add_foreign_key "apartments", "contacts", column: "landlord_id", name: "apartments_landlord_id_fk"
  add_foreign_key "apartments", "identities", name: "apartments_identity_id_fk"
  add_foreign_key "apartments", "locations", name: "apartments_location_id_fk"
  add_foreign_key "awesome_list_items", "awesome_lists"
  add_foreign_key "awesome_list_items", "identities"
  add_foreign_key "awesome_lists", "identities"
  add_foreign_key "awesome_lists", "locations"
  add_foreign_key "bank_accounts", "companies", name: "bank_accounts_company_id_fk"
  add_foreign_key "bank_accounts", "encrypted_values", column: "account_number_encrypted_id", name: "bank_accounts_account_number_encrypted_id_fk"
  add_foreign_key "bank_accounts", "encrypted_values", column: "pin_encrypted_id", name: "bank_accounts_pin_encrypted_id_fk"
  add_foreign_key "bank_accounts", "encrypted_values", column: "routing_number_encrypted_id", name: "bank_accounts_routing_number_encrypted_id_fk"
  add_foreign_key "bank_accounts", "identities", name: "bank_accounts_identity_id_fk"
  add_foreign_key "bank_accounts", "locations", column: "home_address_id", name: "bank_accounts_home_address_id_fk"
  add_foreign_key "bank_accounts", "passwords", name: "bank_accounts_password_id_fk"
  add_foreign_key "bar_pictures", "bars"
  add_foreign_key "bar_pictures", "identities"
  add_foreign_key "bar_pictures", "identity_files"
  add_foreign_key "bars", "identities"
  add_foreign_key "bars", "locations"
  add_foreign_key "beaches", "identities"
  add_foreign_key "beaches", "locations"
  add_foreign_key "bet_contacts", "bets"
  add_foreign_key "bet_contacts", "contacts"
  add_foreign_key "bet_contacts", "identities"
  add_foreign_key "bets", "identities"
  add_foreign_key "bill_files", "bills"
  add_foreign_key "bill_files", "identities"
  add_foreign_key "bill_files", "identity_files"
  add_foreign_key "bills", "identities"
  add_foreign_key "blog_files", "blogs"
  add_foreign_key "blog_files", "identities"
  add_foreign_key "blog_files", "identity_files"
  add_foreign_key "blog_posts", "blogs"
  add_foreign_key "blog_posts", "identities"
  add_foreign_key "blogs", "identities"
  add_foreign_key "blood_concentrations", "identities", name: "blood_concentrations_identity_id_fk"
  add_foreign_key "blood_pressures", "identities", name: "blood_pressures_identity_id_fk"
  add_foreign_key "blood_test_files", "blood_tests"
  add_foreign_key "blood_test_files", "identities"
  add_foreign_key "blood_test_files", "identity_files"
  add_foreign_key "blood_test_results", "blood_concentrations", name: "blood_test_results_blood_concentration_id_fk"
  add_foreign_key "blood_test_results", "blood_tests", name: "blood_test_results_blood_test_id_fk"
  add_foreign_key "blood_test_results", "identities", name: "blood_test_results_identity_id_fk"
  add_foreign_key "blood_tests", "doctors"
  add_foreign_key "blood_tests", "identities", name: "blood_tests_identity_id_fk"
  add_foreign_key "blood_tests", "locations"
  add_foreign_key "book_files", "books"
  add_foreign_key "book_files", "identities"
  add_foreign_key "book_files", "identity_files"
  add_foreign_key "book_quotes", "books"
  add_foreign_key "book_quotes", "identities"
  add_foreign_key "book_quotes", "quotes"
  add_foreign_key "book_stores", "identities"
  add_foreign_key "book_stores", "locations"
  add_foreign_key "books", "contacts", column: "borrowed_from_id"
  add_foreign_key "books", "contacts", column: "gift_from_id"
  add_foreign_key "books", "contacts", column: "lent_to_id"
  add_foreign_key "books", "contacts", column: "recommender_id", name: "books_recommender_id_fk"
  add_foreign_key "books", "identities", name: "books_identity_id_fk"
  add_foreign_key "business_card_files", "business_cards"
  add_foreign_key "business_card_files", "identities"
  add_foreign_key "business_card_files", "identity_files"
  add_foreign_key "business_cards", "contacts"
  add_foreign_key "business_cards", "identities"
  add_foreign_key "cafes", "identities"
  add_foreign_key "cafes", "locations"
  add_foreign_key "calculation_elements", "calculation_operands", column: "left_operand_id", name: "calculation_elements_left_operand_id_fk"
  add_foreign_key "calculation_elements", "calculation_operands", column: "right_operand_id", name: "calculation_elements_right_operand_id_fk"
  add_foreign_key "calculation_elements", "identities", name: "calculation_elements_identity_id_fk"
  add_foreign_key "calculation_forms", "calculation_elements", column: "root_element_id", name: "calculation_forms_root_element_id_fk"
  add_foreign_key "calculation_forms", "identities", name: "calculation_forms_identity_id_fk"
  add_foreign_key "calculation_inputs", "calculation_forms", name: "calculation_inputs_calculation_form_id_fk"
  add_foreign_key "calculation_inputs", "identities", name: "calculation_inputs_identity_id_fk"
  add_foreign_key "calculation_operands", "calculation_elements", name: "calculation_operands_calculation_element_id_fk"
  add_foreign_key "calculation_operands", "calculation_inputs", name: "calculation_operands_calculation_input_id_fk"
  add_foreign_key "calculation_operands", "identities", name: "calculation_operands_identity_id_fk"
  add_foreign_key "calculations", "calculation_forms", column: "original_calculation_form_id", name: "calculations_original_calculation_form_id_fk"
  add_foreign_key "calculations", "calculation_forms", name: "calculations_calculation_form_id_fk"
  add_foreign_key "calculations", "identities", name: "calculations_identity_id_fk"
  add_foreign_key "calendar_item_reminder_pendings", "calendar_item_reminders"
  add_foreign_key "calendar_item_reminder_pendings", "calendar_items"
  add_foreign_key "calendar_item_reminder_pendings", "calendars"
  add_foreign_key "calendar_item_reminder_pendings", "identities"
  add_foreign_key "calendar_item_reminders", "calendar_items"
  add_foreign_key "calendar_item_reminders", "identities"
  add_foreign_key "calendar_items", "calendars"
  add_foreign_key "calendar_items", "identities"
  add_foreign_key "calendars", "identities", name: "calendars_identity_id_fk"
  add_foreign_key "camp_locations", "identities", name: "camp_locations_identity_id_fk"
  add_foreign_key "camp_locations", "locations", name: "camp_locations_location_id_fk"
  add_foreign_key "camp_locations", "memberships", name: "camp_locations_membership_id_fk"
  add_foreign_key "cashbacks", "identities", name: "cashbacks_identity_id_fk"
  add_foreign_key "categories", "categories", column: "parent_id", name: "categories_parent_id_fk"
  add_foreign_key "category_permissions", "identities"
  add_foreign_key "category_permissions", "identities", column: "target_identity_id"
  add_foreign_key "category_permissions", "users"
  add_foreign_key "category_points_amounts", "categories", name: "category_points_amounts_category_id_fk"
  add_foreign_key "category_points_amounts", "identities", name: "category_points_amounts_identity_id_fk"
  add_foreign_key "charities", "identities"
  add_foreign_key "charities", "locations"
  add_foreign_key "check_files", "checks"
  add_foreign_key "check_files", "identities"
  add_foreign_key "check_files", "identity_files"
  add_foreign_key "checklist_items", "checklists", name: "checklist_items_checklist_id_fk"
  add_foreign_key "checklist_items", "identities", name: "checklist_items_identity_id_fk"
  add_foreign_key "checklist_references", "checklists", column: "checklist_parent_id", name: "checklist_references_checklist_parent_id_fk"
  add_foreign_key "checklist_references", "checklists", name: "checklist_references_checklist_id_fk"
  add_foreign_key "checklist_references", "identities", name: "checklist_references_identity_id_fk"
  add_foreign_key "checklists", "identities", name: "checklists_identity_id_fk"
  add_foreign_key "checks", "bank_accounts"
  add_foreign_key "checks", "companies"
  add_foreign_key "checks", "contacts"
  add_foreign_key "checks", "identities"
  add_foreign_key "companies", "identities", column: "company_identity_id"
  add_foreign_key "companies", "identities", name: "companies_identity_id_fk"
  add_foreign_key "company_interaction_files", "company_interactions"
  add_foreign_key "company_interaction_files", "identities"
  add_foreign_key "company_interaction_files", "identity_files"
  add_foreign_key "company_interactions", "companies"
  add_foreign_key "company_interactions", "identities"
  add_foreign_key "complete_due_items", "calendars", name: "complete_due_items_calendar_id_fk"
  add_foreign_key "complete_due_items", "identities", name: "complete_due_items_identity_id_fk"
  add_foreign_key "computer_ssh_keys", "computers"
  add_foreign_key "computer_ssh_keys", "identities"
  add_foreign_key "computer_ssh_keys", "ssh_keys"
  add_foreign_key "computers", "companies", column: "manufacturer_id", name: "computers_manufacturer_id_fk"
  add_foreign_key "computers", "identities", name: "computers_identity_id_fk"
  add_foreign_key "computers", "passwords", column: "administrator_id", name: "computers_administrator_id_fk"
  add_foreign_key "computers", "passwords", column: "main_user_id", name: "computers_main_user_id_fk"
  add_foreign_key "concert_musical_groups", "concerts", name: "concert_musical_groups_concert_id_fk"
  add_foreign_key "concert_musical_groups", "identities", name: "concert_musical_groups_identity_id_fk"
  add_foreign_key "concert_musical_groups", "musical_groups", name: "concert_musical_groups_musical_group_id_fk"
  add_foreign_key "concert_pictures", "concerts"
  add_foreign_key "concert_pictures", "identities"
  add_foreign_key "concert_pictures", "identity_files"
  add_foreign_key "concerts", "identities", name: "concerts_identity_id_fk"
  add_foreign_key "concerts", "locations", name: "concerts_location_id_fk"
  add_foreign_key "connections", "contacts"
  add_foreign_key "connections", "identities"
  add_foreign_key "connections", "users"
  add_foreign_key "consumed_foods", "foods"
  add_foreign_key "consumed_foods", "identities"
  add_foreign_key "contacts", "identities", column: "contact_identity_id", name: "contacts_contact_identity_id_fk"
  add_foreign_key "contacts", "identities", name: "contacts_identity_id_fk"
  add_foreign_key "conversation_files", "conversations"
  add_foreign_key "conversation_files", "identities"
  add_foreign_key "conversation_files", "identity_files"
  add_foreign_key "conversations", "contacts", name: "conversations_contact_id_fk"
  add_foreign_key "conversations", "identities", name: "conversations_identity_id_fk"
  add_foreign_key "credit_card_cashbacks", "cashbacks", name: "credit_card_cashbacks_cashback_id_fk"
  add_foreign_key "credit_card_cashbacks", "credit_cards", name: "credit_card_cashbacks_credit_card_id_fk"
  add_foreign_key "credit_card_cashbacks", "identities", name: "credit_card_cashbacks_identity_id_fk"
  add_foreign_key "credit_card_files", "credit_cards"
  add_foreign_key "credit_card_files", "identities"
  add_foreign_key "credit_card_files", "identity_files"
  add_foreign_key "credit_cards", "encrypted_values", column: "expires_encrypted_id", name: "credit_cards_expires_encrypted_id_fk"
  add_foreign_key "credit_cards", "encrypted_values", column: "number_encrypted_id", name: "credit_cards_number_encrypted_id_fk"
  add_foreign_key "credit_cards", "encrypted_values", column: "pin_encrypted_id", name: "credit_cards_pin_encrypted_id_fk"
  add_foreign_key "credit_cards", "encrypted_values", column: "security_code_encrypted_id", name: "credit_cards_security_code_encrypted_id_fk"
  add_foreign_key "credit_cards", "identities", name: "credit_cards_identity_id_fk"
  add_foreign_key "credit_cards", "locations", column: "address_id", name: "credit_cards_address_id_fk"
  add_foreign_key "credit_cards", "passwords", name: "credit_cards_password_id_fk"
  add_foreign_key "credit_score_files", "credit_scores"
  add_foreign_key "credit_score_files", "identities"
  add_foreign_key "credit_score_files", "identity_files"
  add_foreign_key "credit_scores", "identities", name: "credit_scores_identity_id_fk"
  add_foreign_key "date_locations", "identities", name: "date_locations_identity_id_fk"
  add_foreign_key "date_locations", "locations", name: "date_locations_location_id_fk"
  add_foreign_key "dating_profile_files", "dating_profiles"
  add_foreign_key "dating_profile_files", "identities"
  add_foreign_key "dating_profile_files", "identity_files"
  add_foreign_key "dating_profiles", "identities"
  add_foreign_key "dental_insurance_files", "dental_insurances"
  add_foreign_key "dental_insurance_files", "identities"
  add_foreign_key "dental_insurance_files", "identity_files"
  add_foreign_key "dental_insurances", "companies", column: "group_company_id", name: "dental_insurances_group_company_id_fk"
  add_foreign_key "dental_insurances", "companies", column: "insurance_company_id", name: "dental_insurances_insurance_company_id_fk"
  add_foreign_key "dental_insurances", "doctors", name: "dental_insurances_doctor_id_fk"
  add_foreign_key "dental_insurances", "identities", name: "dental_insurances_identity_id_fk"
  add_foreign_key "dental_insurances", "passwords", name: "dental_insurances_password_id_fk"
  add_foreign_key "dental_insurances", "periodic_payments", name: "dental_insurances_periodic_payment_id_fk"
  add_foreign_key "dentist_visits", "dental_insurances", name: "dentist_visits_dental_insurance_id_fk"
  add_foreign_key "dentist_visits", "doctors", column: "dentist_id", name: "dentist_visits_dentist_id_fk"
  add_foreign_key "dentist_visits", "identities", name: "dentist_visits_identity_id_fk"
  add_foreign_key "desired_locations", "identities"
  add_foreign_key "desired_locations", "locations"
  add_foreign_key "desired_locations", "websites"
  add_foreign_key "desired_products", "identities", name: "desired_products_identity_id_fk"
  add_foreign_key "dessert_locations", "identities"
  add_foreign_key "dessert_locations", "locations"
  add_foreign_key "diary_entries", "encrypted_values", column: "entry_encrypted_id"
  add_foreign_key "diary_entries", "identities", name: "diary_entries_identity_id_fk"
  add_foreign_key "diet_foods", "diets"
  add_foreign_key "diet_foods", "foods"
  add_foreign_key "diet_foods", "identities"
  add_foreign_key "dietary_requirements", "dietary_requirements_collections"
  add_foreign_key "dietary_requirements", "identities"
  add_foreign_key "dietary_requirements_collection_files", "dietary_requirements_collections"
  add_foreign_key "dietary_requirements_collection_files", "identities"
  add_foreign_key "dietary_requirements_collection_files", "identity_files"
  add_foreign_key "dietary_requirements_collections", "identities"
  add_foreign_key "diets", "dietary_requirements_collections"
  add_foreign_key "diets", "identities"
  add_foreign_key "doctor_visit_files", "doctor_visits"
  add_foreign_key "doctor_visit_files", "identities"
  add_foreign_key "doctor_visit_files", "identity_files"
  add_foreign_key "doctor_visits", "doctors", name: "doctor_visits_doctor_id_fk"
  add_foreign_key "doctor_visits", "health_insurances", name: "doctor_visits_health_insurance_id_fk"
  add_foreign_key "doctor_visits", "identities", name: "doctor_visits_identity_id_fk"
  add_foreign_key "doctors", "contacts", name: "doctors_contact_id_fk"
  add_foreign_key "doctors", "identities", name: "doctors_identity_id_fk"
  add_foreign_key "document_files", "documents"
  add_foreign_key "document_files", "identities"
  add_foreign_key "document_files", "identity_files"
  add_foreign_key "documents", "identities"
  add_foreign_key "donation_files", "donations"
  add_foreign_key "donation_files", "identities"
  add_foreign_key "donation_files", "identity_files"
  add_foreign_key "donations", "identities"
  add_foreign_key "donations", "locations"
  add_foreign_key "drafts", "identities"
  add_foreign_key "dreams", "encrypted_values", column: "dream_encrypted_id"
  add_foreign_key "dreams", "identities"
  add_foreign_key "drinks", "identities", name: "drinks_identity_id_fk"
  add_foreign_key "driver_license_files", "driver_licenses"
  add_foreign_key "driver_license_files", "identities"
  add_foreign_key "driver_license_files", "identity_files"
  add_foreign_key "driver_licenses", "identities"
  add_foreign_key "driver_licenses", "locations", column: "address_id"
  add_foreign_key "due_items", "calendars", name: "due_items_calendar_id_fk"
  add_foreign_key "due_items", "identities", name: "due_items_identity_id_fk"
  add_foreign_key "education_files", "educations"
  add_foreign_key "education_files", "identities"
  add_foreign_key "education_files", "identity_files"
  add_foreign_key "educations", "identities"
  add_foreign_key "educations", "locations"
  add_foreign_key "email_accounts", "identities"
  add_foreign_key "email_accounts", "passwords"
  add_foreign_key "email_contacts", "contacts"
  add_foreign_key "email_contacts", "emails"
  add_foreign_key "email_contacts", "identities"
  add_foreign_key "email_groups", "emails"
  add_foreign_key "email_groups", "groups"
  add_foreign_key "email_groups", "identities"
  add_foreign_key "email_personalizations", "emails"
  add_foreign_key "email_personalizations", "identities"
  add_foreign_key "email_tokens", "identities"
  add_foreign_key "email_unsubscriptions", "identities"
  add_foreign_key "emails", "identities"
  add_foreign_key "emergency_contacts", "emails"
  add_foreign_key "emergency_contacts", "identities"
  add_foreign_key "encrypted_values", "users", name: "encrypted_values_user_id_fk"
  add_foreign_key "event_contacts", "contacts"
  add_foreign_key "event_contacts", "events"
  add_foreign_key "event_contacts", "identities"
  add_foreign_key "event_pictures", "events"
  add_foreign_key "event_pictures", "identities"
  add_foreign_key "event_pictures", "identity_files"
  add_foreign_key "event_rsvps", "events"
  add_foreign_key "event_rsvps", "identities"
  add_foreign_key "event_stories", "events"
  add_foreign_key "event_stories", "identities"
  add_foreign_key "event_stories", "stories"
  add_foreign_key "events", "identities", name: "events_identity_id_fk"
  add_foreign_key "events", "locations", name: "events_location_id_fk"
  add_foreign_key "events", "repeats", name: "events_repeat_id_fk"
  add_foreign_key "exercise_regimen_exercise_files", "exercise_regimen_exercises"
  add_foreign_key "exercise_regimen_exercise_files", "identities"
  add_foreign_key "exercise_regimen_exercise_files", "identity_files"
  add_foreign_key "exercise_regimen_exercises", "exercise_regimens"
  add_foreign_key "exercise_regimen_exercises", "identities"
  add_foreign_key "exercise_regimens", "identities"
  add_foreign_key "exercises", "identities", name: "exercises_identity_id_fk"
  add_foreign_key "favorite_locations", "identities"
  add_foreign_key "favorite_locations", "locations"
  add_foreign_key "favorite_product_files", "favorite_products"
  add_foreign_key "favorite_product_files", "identities"
  add_foreign_key "favorite_product_files", "identity_files"
  add_foreign_key "favorite_product_links", "favorite_products"
  add_foreign_key "favorite_product_links", "identities"
  add_foreign_key "favorite_products", "identities", name: "favorite_products_identity_id_fk"
  add_foreign_key "feed_items", "feeds"
  add_foreign_key "feed_items", "identities"
  add_foreign_key "feed_load_statuses", "identities"
  add_foreign_key "feeds", "identities", name: "feeds_identity_id_fk"
  add_foreign_key "flight_legs", "companies", column: "flight_company_id"
  add_foreign_key "flight_legs", "flights"
  add_foreign_key "flight_legs", "identities"
  add_foreign_key "flight_legs", "locations", column: "arrival_location_id"
  add_foreign_key "flight_legs", "locations", column: "depart_location_id"
  add_foreign_key "flights", "identities"
  add_foreign_key "food_files", "foods"
  add_foreign_key "food_files", "identities"
  add_foreign_key "food_files", "identity_files"
  add_foreign_key "food_informations", "identities"
  add_foreign_key "food_ingredients", "foods", column: "parent_food_id", name: "food_ingredients_parent_food_id_fk"
  add_foreign_key "food_ingredients", "foods", name: "food_ingredients_food_id_fk"
  add_foreign_key "food_ingredients", "identities", name: "food_ingredients_identity_id_fk"
  add_foreign_key "food_nutrient_informations", "identities"
  add_foreign_key "food_nutrition_information_amounts", "food_nutrition_informations"
  add_foreign_key "food_nutrition_information_amounts", "identities"
  add_foreign_key "food_nutrition_information_amounts", "nutrients"
  add_foreign_key "food_nutrition_information_files", "food_nutrition_informations"
  add_foreign_key "food_nutrition_information_files", "identities"
  add_foreign_key "food_nutrition_information_files", "identity_files"
  add_foreign_key "food_nutrition_informations", "identities"
  add_foreign_key "foods", "food_informations"
  add_foreign_key "foods", "food_nutrition_informations"
  add_foreign_key "foods", "identities", name: "foods_identity_id_fk"
  add_foreign_key "gas_stations", "identities", name: "gas_stations_identity_id_fk"
  add_foreign_key "gas_stations", "locations", name: "gas_stations_location_id_fk"
  add_foreign_key "group_contacts", "contacts", name: "group_contacts_contact_id_fk"
  add_foreign_key "group_contacts", "groups", name: "group_contacts_group_id_fk"
  add_foreign_key "group_contacts", "identities", name: "group_contacts_identity_id_fk"
  add_foreign_key "group_references", "groups"
  add_foreign_key "group_references", "groups", column: "parent_group_id"
  add_foreign_key "group_references", "identities"
  add_foreign_key "groups", "identities", name: "groups_identity_id_fk"
  add_foreign_key "gun_files", "guns"
  add_foreign_key "gun_files", "identities"
  add_foreign_key "gun_files", "identity_files"
  add_foreign_key "gun_registration_files", "gun_registrations"
  add_foreign_key "gun_registration_files", "identities"
  add_foreign_key "gun_registration_files", "identity_files"
  add_foreign_key "gun_registrations", "guns", name: "gun_registrations_gun_id_fk"
  add_foreign_key "gun_registrations", "identities", name: "gun_registrations_identity_id_fk"
  add_foreign_key "gun_registrations", "locations", name: "gun_registrations_location_id_fk"
  add_foreign_key "guns", "identities", name: "guns_identity_id_fk"
  add_foreign_key "happy_things", "identities"
  add_foreign_key "headaches", "identities", name: "headaches_identity_id_fk"
  add_foreign_key "health_insurance_files", "health_insurances"
  add_foreign_key "health_insurance_files", "identities"
  add_foreign_key "health_insurance_files", "identity_files"
  add_foreign_key "health_insurances", "companies", column: "group_company_id", name: "health_insurances_group_company_id_fk"
  add_foreign_key "health_insurances", "companies", column: "insurance_company_id", name: "health_insurances_insurance_company_id_fk"
  add_foreign_key "health_insurances", "doctors", name: "health_insurances_doctor_id_fk"
  add_foreign_key "health_insurances", "identities", name: "health_insurances_identity_id_fk"
  add_foreign_key "health_insurances", "passwords", name: "health_insurances_password_id_fk"
  add_foreign_key "health_insurances", "periodic_payments", name: "health_insurances_periodic_payment_id_fk"
  add_foreign_key "heart_rates", "identities", name: "heart_rates_identity_id_fk"
  add_foreign_key "heights", "identities", name: "heights_identity_id_fk"
  add_foreign_key "hobbies", "identities", name: "hobbies_identity_id_fk"
  add_foreign_key "hospital_visit_files", "hospital_visits"
  add_foreign_key "hospital_visit_files", "identities"
  add_foreign_key "hospital_visit_files", "identity_files"
  add_foreign_key "hospital_visits", "identities"
  add_foreign_key "hospital_visits", "locations", column: "hospital_id"
  add_foreign_key "hotels", "identities"
  add_foreign_key "hotels", "locations"
  add_foreign_key "hypotheses", "identities", name: "hypotheses_identity_id_fk"
  add_foreign_key "hypotheses", "questions", name: "hypotheses_question_id_fk"
  add_foreign_key "hypothesis_experiments", "hypotheses", name: "hypothesis_experiments_hypothesis_id_fk"
  add_foreign_key "hypothesis_experiments", "identities", name: "hypothesis_experiments_identity_id_fk"
  add_foreign_key "ideas", "identities", name: "ideas_identity_id_fk"
  add_foreign_key "identities", "companies"
  add_foreign_key "identities", "identities"
  add_foreign_key "identities", "users", name: "identities_user_id_fk"
  add_foreign_key "identity_drivers_licenses", "identities", column: "parent_identity_id", name: "identity_drivers_licenses_parent_identity_id_fk"
  add_foreign_key "identity_drivers_licenses", "identities", name: "identity_drivers_licenses_identity_id_fk"
  add_foreign_key "identity_drivers_licenses", "identity_files", name: "identity_drivers_licenses_identity_file_id_fk"
  add_foreign_key "identity_emails", "identities", column: "parent_identity_id", name: "identity_emails_parent_identity_id_fk"
  add_foreign_key "identity_emails", "identities", name: "identity_emails_identity_id_fk"
  add_foreign_key "identity_file_folders", "identities", name: "identity_file_folders_identity_id_fk"
  add_foreign_key "identity_file_folders", "identity_file_folders", column: "parent_folder_id", name: "identity_file_folders_parent_folder_id_fk"
  add_foreign_key "identity_files", "encrypted_values", column: "encrypted_password_id", name: "identity_files_encrypted_password_id_fk"
  add_foreign_key "identity_files", "identities", name: "identity_files_identity_id_fk"
  add_foreign_key "identity_files", "identity_file_folders", column: "folder_id", name: "identity_files_folder_id_fk"
  add_foreign_key "identity_locations", "identities", column: "parent_identity_id", name: "identity_locations_parent_identity_id_fk"
  add_foreign_key "identity_locations", "identities", name: "identity_locations_identity_id_fk"
  add_foreign_key "identity_locations", "locations", name: "identity_locations_location_id_fk"
  add_foreign_key "identity_phones", "identities", column: "parent_identity_id", name: "identity_phones_parent_identity_id_fk"
  add_foreign_key "identity_phones", "identities", name: "identity_phones_identity_id_fk"
  add_foreign_key "identity_pictures", "identities", column: "parent_identity_id", name: "identity_pictures_parent_identity_id_fk"
  add_foreign_key "identity_pictures", "identities", name: "identity_pictures_identity_id_fk"
  add_foreign_key "identity_pictures", "identity_files", name: "identity_pictures_identity_file_id_fk"
  add_foreign_key "identity_relationships", "contacts", name: "identity_relationships_contact_id_fk"
  add_foreign_key "identity_relationships", "identities", column: "parent_identity_id", name: "identity_relationships_parent_identity_id_fk"
  add_foreign_key "identity_relationships", "identities", name: "identity_relationships_identity_id_fk"
  add_foreign_key "import_files", "identities"
  add_foreign_key "import_files", "identity_files"
  add_foreign_key "import_files", "imports"
  add_foreign_key "imports", "identities"
  add_foreign_key "injuries", "identities"
  add_foreign_key "injuries", "locations"
  add_foreign_key "injury_files", "identities"
  add_foreign_key "injury_files", "identity_files"
  add_foreign_key "injury_files", "injuries"
  add_foreign_key "insurance_card_files", "identities"
  add_foreign_key "insurance_card_files", "identity_files"
  add_foreign_key "insurance_card_files", "insurance_cards"
  add_foreign_key "insurance_cards", "identities"
  add_foreign_key "invite_codes", "identities"
  add_foreign_key "invites", "users"
  add_foreign_key "item_files", "identities"
  add_foreign_key "item_files", "identity_files"
  add_foreign_key "item_files", "items"
  add_foreign_key "items", "identities"
  add_foreign_key "job_accomplishments", "identities"
  add_foreign_key "job_accomplishments", "jobs"
  add_foreign_key "job_awards", "identities"
  add_foreign_key "job_files", "identities"
  add_foreign_key "job_files", "identity_files"
  add_foreign_key "job_files", "jobs"
  add_foreign_key "job_managers", "contacts"
  add_foreign_key "job_managers", "identities"
  add_foreign_key "job_managers", "jobs"
  add_foreign_key "job_myreferences", "identities"
  add_foreign_key "job_myreferences", "jobs"
  add_foreign_key "job_myreferences", "myreferences"
  add_foreign_key "job_review_files", "identities"
  add_foreign_key "job_review_files", "identity_files"
  add_foreign_key "job_review_files", "job_reviews"
  add_foreign_key "job_reviews", "contacts"
  add_foreign_key "job_reviews", "identities"
  add_foreign_key "job_reviews", "jobs"
  add_foreign_key "job_salaries", "identities", name: "job_salaries_identity_id_fk"
  add_foreign_key "job_salaries", "jobs", name: "job_salaries_job_id_fk"
  add_foreign_key "jobs", "companies", name: "jobs_company_id_fk"
  add_foreign_key "jobs", "contacts", column: "manager_contact_id", name: "jobs_manager_contact_id_fk"
  add_foreign_key "jobs", "identities", name: "jobs_identity_id_fk"
  add_foreign_key "jobs", "locations", column: "internal_address_id", name: "jobs_internal_address_id_fk"
  add_foreign_key "jokes", "identities", name: "jokes_identity_id_fk"
  add_foreign_key "last_text_messages", "identities", column: "from_identity_id"
  add_foreign_key "last_text_messages", "identities", column: "to_identity_id"
  add_foreign_key "life_goals", "identities", name: "life_goals_identity_id_fk"
  add_foreign_key "life_highlight_files", "identities"
  add_foreign_key "life_highlight_files", "identity_files"
  add_foreign_key "life_highlight_files", "life_highlights"
  add_foreign_key "life_highlights", "identities"
  add_foreign_key "life_insurance_files", "identities"
  add_foreign_key "life_insurance_files", "identity_files"
  add_foreign_key "life_insurance_files", "life_insurances"
  add_foreign_key "life_insurances", "companies", name: "life_insurances_company_id_fk"
  add_foreign_key "life_insurances", "contacts", column: "beneficiary_id"
  add_foreign_key "life_insurances", "identities", name: "life_insurances_identity_id_fk"
  add_foreign_key "life_insurances", "periodic_payments", name: "life_insurances_periodic_payment_id_fk"
  add_foreign_key "list_items", "identities", name: "list_items_identity_id_fk"
  add_foreign_key "list_items", "lists", name: "list_items_list_id_fk"
  add_foreign_key "lists", "identities", name: "lists_identity_id_fk"
  add_foreign_key "loans", "identities", name: "loans_identity_id_fk"
  add_foreign_key "location_phones", "identities", name: "location_phones_identity_id_fk"
  add_foreign_key "location_phones", "locations", name: "location_phones_location_id_fk"
  add_foreign_key "location_pictures", "identities"
  add_foreign_key "location_pictures", "identity_files"
  add_foreign_key "location_pictures", "locations"
  add_foreign_key "locations", "identities", name: "locations_identity_id_fk"
  add_foreign_key "locations", "websites"
  add_foreign_key "meadows", "identities"
  add_foreign_key "meadows", "locations"
  add_foreign_key "meal_drinks", "drinks", name: "meal_drinks_drink_id_fk"
  add_foreign_key "meal_drinks", "identities", name: "meal_drinks_identity_id_fk"
  add_foreign_key "meal_drinks", "meals", name: "meal_drinks_meal_id_fk"
  add_foreign_key "meal_foods", "foods", name: "meal_foods_food_id_fk"
  add_foreign_key "meal_foods", "identities", name: "meal_foods_identity_id_fk"
  add_foreign_key "meal_foods", "meals", name: "meal_foods_meal_id_fk"
  add_foreign_key "meal_vitamins", "identities", name: "meal_vitamins_identity_id_fk"
  add_foreign_key "meal_vitamins", "meals", name: "meal_vitamins_meal_id_fk"
  add_foreign_key "meal_vitamins", "vitamins", name: "meal_vitamins_vitamin_id_fk"
  add_foreign_key "meals", "identities", name: "meals_identity_id_fk"
  add_foreign_key "meals", "locations", name: "meals_location_id_fk"
  add_foreign_key "media_dump_files", "identities"
  add_foreign_key "media_dump_files", "identity_files"
  add_foreign_key "media_dump_files", "media_dumps"
  add_foreign_key "media_dumps", "identities"
  add_foreign_key "medical_condition_evaluation_files", "identities"
  add_foreign_key "medical_condition_evaluation_files", "identity_files"
  add_foreign_key "medical_condition_evaluation_files", "medical_condition_evaluations"
  add_foreign_key "medical_condition_evaluations", "identities"
  add_foreign_key "medical_condition_evaluations", "medical_conditions"
  add_foreign_key "medical_condition_files", "identities"
  add_foreign_key "medical_condition_files", "identity_files"
  add_foreign_key "medical_condition_files", "medical_conditions"
  add_foreign_key "medical_condition_instances", "identities", name: "medical_condition_instances_identity_id_fk"
  add_foreign_key "medical_condition_instances", "medical_conditions", name: "medical_condition_instances_medical_condition_id_fk"
  add_foreign_key "medical_condition_treatments", "doctors"
  add_foreign_key "medical_condition_treatments", "identities"
  add_foreign_key "medical_condition_treatments", "locations"
  add_foreign_key "medical_condition_treatments", "medical_conditions"
  add_foreign_key "medical_conditions", "identities", name: "medical_conditions_identity_id_fk"
  add_foreign_key "medicine_usage_medicines", "identities", name: "medicine_usage_medicines_identity_id_fk"
  add_foreign_key "medicine_usage_medicines", "medicine_usages", name: "medicine_usage_medicines_medicine_usage_id_fk"
  add_foreign_key "medicine_usage_medicines", "medicines", name: "medicine_usage_medicines_medicine_id_fk"
  add_foreign_key "medicine_usages", "identities", name: "medicine_usages_identity_id_fk"
  add_foreign_key "medicines", "identities", name: "medicines_identity_id_fk"
  add_foreign_key "membership_files", "identities"
  add_foreign_key "membership_files", "identity_files"
  add_foreign_key "membership_files", "memberships"
  add_foreign_key "memberships", "identities", name: "memberships_identity_id_fk"
  add_foreign_key "memberships", "passwords"
  add_foreign_key "memberships", "periodic_payments", name: "memberships_periodic_payment_id_fk"
  add_foreign_key "memories", "identities"
  add_foreign_key "memory_files", "identities"
  add_foreign_key "memory_files", "identity_files"
  add_foreign_key "memory_files", "memories"
  add_foreign_key "message_contacts", "contacts"
  add_foreign_key "message_contacts", "identities"
  add_foreign_key "message_contacts", "messages"
  add_foreign_key "message_groups", "groups"
  add_foreign_key "message_groups", "identities"
  add_foreign_key "message_groups", "messages"
  add_foreign_key "messages", "identities"
  add_foreign_key "money_balance_item_templates", "identities"
  add_foreign_key "money_balance_item_templates", "money_balances"
  add_foreign_key "money_balance_items", "identities"
  add_foreign_key "money_balance_items", "money_balances"
  add_foreign_key "money_balances", "contacts"
  add_foreign_key "money_balances", "identities"
  add_foreign_key "movie_theaters", "identities", name: "movie_theaters_identity_id_fk"
  add_foreign_key "movie_theaters", "locations", name: "movie_theaters_location_id_fk"
  add_foreign_key "movies", "contacts", column: "borrowed_from_id"
  add_foreign_key "movies", "contacts", column: "lent_to_id"
  add_foreign_key "movies", "contacts", column: "recommender_id", name: "movies_recommender_id_fk"
  add_foreign_key "movies", "identities", name: "movies_identity_id_fk"
  add_foreign_key "museums", "identities", name: "museums_identity_id_fk"
  add_foreign_key "museums", "locations", name: "museums_location_id_fk"
  add_foreign_key "museums", "websites", name: "museums_website_id_fk"
  add_foreign_key "music_album_files", "identities"
  add_foreign_key "music_album_files", "identity_files"
  add_foreign_key "music_album_files", "music_albums"
  add_foreign_key "music_albums", "identities"
  add_foreign_key "musical_groups", "identities", name: "musical_groups_identity_id_fk"
  add_foreign_key "myplaceonline_quick_category_displays", "identities", name: "myplaceonline_quick_category_displays_identity_id_fk"
  add_foreign_key "myplaceonline_searches", "identities", name: "myplaceonline_searches_identity_id_fk"
  add_foreign_key "myplets", "identities", name: "myplets_identity_id_fk"
  add_foreign_key "myreferences", "contacts"
  add_foreign_key "myreferences", "identities"
  add_foreign_key "notepads", "identities", name: "notepads_identity_id_fk"
  add_foreign_key "nutrients", "identities"
  add_foreign_key "paid_tax_files", "identities"
  add_foreign_key "paid_tax_files", "identity_files"
  add_foreign_key "paid_tax_files", "paid_taxes"
  add_foreign_key "paid_taxes", "identities"
  add_foreign_key "paid_taxes", "passwords"
  add_foreign_key "pains", "identities", name: "pains_identity_id_fk"
  add_foreign_key "passport_pictures", "identities", name: "passport_pictures_identity_id_fk"
  add_foreign_key "passport_pictures", "identity_files", name: "passport_pictures_identity_file_id_fk"
  add_foreign_key "passport_pictures", "passports", name: "passport_pictures_passport_id_fk"
  add_foreign_key "passports", "identities", name: "passports_identity_id_fk"
  add_foreign_key "password_secret_shares", "identities"
  add_foreign_key "password_secret_shares", "password_secrets"
  add_foreign_key "password_secret_shares", "password_shares"
  add_foreign_key "password_secrets", "encrypted_values", column: "answer_encrypted_id", name: "password_secrets_answer_encrypted_id_fk"
  add_foreign_key "password_secrets", "identities", name: "password_secrets_identity_id_fk"
  add_foreign_key "password_secrets", "passwords", name: "password_secrets_password_id_fk"
  add_foreign_key "password_shares", "identities"
  add_foreign_key "password_shares", "passwords"
  add_foreign_key "password_shares", "users"
  add_foreign_key "passwords", "encrypted_values", column: "password_encrypted_id", name: "passwords_password_encrypted_id_fk"
  add_foreign_key "passwords", "identities", name: "passwords_identity_id_fk"
  add_foreign_key "patent_files", "identities"
  add_foreign_key "patent_files", "identity_files"
  add_foreign_key "patent_files", "patents"
  add_foreign_key "patents", "identities"
  add_foreign_key "periodic_payment_instance_files", "identities"
  add_foreign_key "periodic_payment_instance_files", "identity_files"
  add_foreign_key "periodic_payment_instance_files", "periodic_payment_instances"
  add_foreign_key "periodic_payment_instances", "identities"
  add_foreign_key "periodic_payment_instances", "periodic_payments"
  add_foreign_key "periodic_payments", "identities", name: "periodic_payments_identity_id_fk"
  add_foreign_key "periodic_payments", "passwords"
  add_foreign_key "perishable_foods", "foods"
  add_foreign_key "perishable_foods", "identities"
  add_foreign_key "permission_share_children", "identities"
  add_foreign_key "permission_share_children", "permission_shares"
  add_foreign_key "permission_share_children", "shares"
  add_foreign_key "permission_shares", "emails"
  add_foreign_key "permission_shares", "identities"
  add_foreign_key "permission_shares", "shares"
  add_foreign_key "permissions", "identities"
  add_foreign_key "permissions", "users"
  add_foreign_key "phone_files", "identities"
  add_foreign_key "phone_files", "identity_files"
  add_foreign_key "phone_files", "phones"
  add_foreign_key "phones", "companies", column: "manufacturer_id", name: "phones_manufacturer_id_fk"
  add_foreign_key "phones", "identities", name: "phones_identity_id_fk"
  add_foreign_key "phones", "passwords", name: "phones_password_id_fk"
  add_foreign_key "picnic_locations", "identities"
  add_foreign_key "picnic_locations", "locations"
  add_foreign_key "playlist_songs", "identities", name: "playlist_songs_identity_id_fk"
  add_foreign_key "playlist_songs", "playlists", name: "playlist_songs_playlist_id_fk"
  add_foreign_key "playlist_songs", "songs", name: "playlist_songs_song_id_fk"
  add_foreign_key "playlists", "identities", name: "playlists_identity_id_fk"
  add_foreign_key "playlists", "identity_files"
  add_foreign_key "podcasts", "feeds"
  add_foreign_key "podcasts", "identities"
  add_foreign_key "poems", "identities", name: "poems_identity_id_fk"
  add_foreign_key "point_displays", "identities", name: "point_displays_identity_id_fk"
  add_foreign_key "prescription_files", "identities"
  add_foreign_key "prescription_files", "identity_files"
  add_foreign_key "prescription_files", "prescriptions"
  add_foreign_key "prescription_refills", "identities"
  add_foreign_key "prescription_refills", "locations"
  add_foreign_key "prescription_refills", "prescriptions"
  add_foreign_key "prescriptions", "contacts", column: "doctor_id"
  add_foreign_key "prescriptions", "identities"
  add_foreign_key "problem_report_files", "identities"
  add_foreign_key "problem_report_files", "identity_files"
  add_foreign_key "problem_report_files", "problem_reports"
  add_foreign_key "problem_reports", "identities"
  add_foreign_key "project_issue_files", "identities"
  add_foreign_key "project_issue_files", "identity_files"
  add_foreign_key "project_issue_files", "project_issues"
  add_foreign_key "project_issue_notifiers", "contacts"
  add_foreign_key "project_issue_notifiers", "identities"
  add_foreign_key "project_issue_notifiers", "project_issues"
  add_foreign_key "project_issues", "identities"
  add_foreign_key "project_issues", "projects"
  add_foreign_key "projects", "identities"
  add_foreign_key "promises", "identities", name: "promises_identity_id_fk"
  add_foreign_key "promotions", "identities", name: "promotions_identity_id_fk"
  add_foreign_key "psychological_evaluation_files", "identities"
  add_foreign_key "psychological_evaluation_files", "identity_files"
  add_foreign_key "psychological_evaluation_files", "psychological_evaluations"
  add_foreign_key "psychological_evaluations", "contacts", column: "evaluator_id"
  add_foreign_key "psychological_evaluations", "identities"
  add_foreign_key "quest_files", "identities"
  add_foreign_key "quest_files", "identity_files"
  add_foreign_key "quest_files", "quests"
  add_foreign_key "questions", "identities", name: "questions_identity_id_fk"
  add_foreign_key "quests", "identities"
  add_foreign_key "quotes", "identities"
  add_foreign_key "receipt_files", "identities"
  add_foreign_key "receipt_files", "identity_files"
  add_foreign_key "receipt_files", "receipts"
  add_foreign_key "receipts", "identities"
  add_foreign_key "recipe_pictures", "identities"
  add_foreign_key "recipe_pictures", "identity_files"
  add_foreign_key "recipe_pictures", "recipes"
  add_foreign_key "recipes", "identities", name: "recipes_identity_id_fk"
  add_foreign_key "recreational_vehicle_insurances", "companies", name: "recreational_vehicle_insurances_company_id_fk"
  add_foreign_key "recreational_vehicle_insurances", "identities", name: "recreational_vehicle_insurances_identity_id_fk"
  add_foreign_key "recreational_vehicle_insurances", "periodic_payments", name: "recreational_vehicle_insurances_periodic_payment_id_fk"
  add_foreign_key "recreational_vehicle_insurances", "recreational_vehicles", name: "recreational_vehicle_insurances_recreational_vehicle_id_fk"
  add_foreign_key "recreational_vehicle_loans", "identities", name: "recreational_vehicle_loans_identity_id_fk"
  add_foreign_key "recreational_vehicle_loans", "loans", name: "recreational_vehicle_loans_loan_id_fk"
  add_foreign_key "recreational_vehicle_loans", "recreational_vehicles", name: "recreational_vehicle_loans_recreational_vehicle_id_fk"
  add_foreign_key "recreational_vehicle_measurements", "identities", name: "recreational_vehicle_measurements_identity_id_fk"
  add_foreign_key "recreational_vehicle_measurements", "recreational_vehicles", name: "recreational_vehicle_measurements_recreational_vehicle_id_fk"
  add_foreign_key "recreational_vehicle_pictures", "identities", name: "recreational_vehicle_pictures_identity_id_fk"
  add_foreign_key "recreational_vehicle_pictures", "identity_files", name: "recreational_vehicle_pictures_identity_file_id_fk"
  add_foreign_key "recreational_vehicle_pictures", "recreational_vehicles", name: "recreational_vehicle_pictures_recreational_vehicle_id_fk"
  add_foreign_key "recreational_vehicle_service_files", "identities"
  add_foreign_key "recreational_vehicle_service_files", "identity_files"
  add_foreign_key "recreational_vehicle_service_files", "recreational_vehicle_services"
  add_foreign_key "recreational_vehicle_services", "identities"
  add_foreign_key "recreational_vehicle_services", "recreational_vehicles"
  add_foreign_key "recreational_vehicles", "identities", name: "recreational_vehicles_identity_id_fk"
  add_foreign_key "recreational_vehicles", "locations", column: "location_purchased_id", name: "recreational_vehicles_location_purchased_id_fk"
  add_foreign_key "regimen_items", "identities"
  add_foreign_key "regimen_items", "regimens"
  add_foreign_key "regimens", "identities"
  add_foreign_key "repeats", "identities", name: "repeats_identity_id_fk"
  add_foreign_key "restaurant_pictures", "identities"
  add_foreign_key "restaurant_pictures", "identity_files"
  add_foreign_key "restaurant_pictures", "restaurants"
  add_foreign_key "restaurants", "identities", name: "restaurants_identity_id_fk"
  add_foreign_key "restaurants", "locations", name: "restaurants_location_id_fk"
  add_foreign_key "retirement_plan_amount_files", "identities"
  add_foreign_key "retirement_plan_amount_files", "identity_files"
  add_foreign_key "retirement_plan_amount_files", "retirement_plan_amounts"
  add_foreign_key "retirement_plan_amounts", "identities"
  add_foreign_key "retirement_plan_amounts", "retirement_plans"
  add_foreign_key "retirement_plans", "companies"
  add_foreign_key "retirement_plans", "identities"
  add_foreign_key "retirement_plans", "passwords"
  add_foreign_key "retirement_plans", "periodic_payments"
  add_foreign_key "reward_program_files", "identities"
  add_foreign_key "reward_program_files", "identity_files"
  add_foreign_key "reward_program_files", "reward_programs"
  add_foreign_key "reward_programs", "identities", name: "reward_programs_identity_id_fk"
  add_foreign_key "reward_programs", "passwords", name: "reward_programs_password_id_fk"
  add_foreign_key "settings", "categories"
  add_foreign_key "settings", "identities"
  add_foreign_key "shares", "identities", name: "shares_identity_id_fk"
  add_foreign_key "shopping_list_items", "identities", name: "shopping_list_items_identity_id_fk"
  add_foreign_key "shopping_list_items", "shopping_lists", name: "shopping_list_items_shopping_list_id_fk"
  add_foreign_key "shopping_lists", "identities", name: "shopping_lists_identity_id_fk"
  add_foreign_key "sickness_files", "identities"
  add_foreign_key "sickness_files", "identity_files"
  add_foreign_key "sickness_files", "sicknesses"
  add_foreign_key "sicknesses", "identities"
  add_foreign_key "skin_treatments", "identities", name: "skin_treatments_identity_id_fk"
  add_foreign_key "sleep_measurements", "identities", name: "sleep_measurements_identity_id_fk"
  add_foreign_key "snoozed_due_items", "calendars", name: "snoozed_due_items_calendar_id_fk"
  add_foreign_key "snoozed_due_items", "identities", name: "snoozed_due_items_identity_id_fk"
  add_foreign_key "software_license_files", "identities"
  add_foreign_key "software_license_files", "identity_files"
  add_foreign_key "software_license_files", "software_licenses"
  add_foreign_key "software_licenses", "identities"
  add_foreign_key "songs", "identities", name: "songs_identity_id_fk"
  add_foreign_key "songs", "identity_files", name: "songs_identity_file_id_fk"
  add_foreign_key "songs", "musical_groups", name: "songs_musical_group_id_fk"
  add_foreign_key "ssh_keys", "encrypted_values", column: "ssh_private_key_encrypted_id"
  add_foreign_key "ssh_keys", "identities"
  add_foreign_key "ssh_keys", "passwords"
  add_foreign_key "statuses", "identities", name: "statuses_identity_id_fk"
  add_foreign_key "stocks", "companies", name: "stocks_company_id_fk"
  add_foreign_key "stocks", "identities", name: "stocks_identity_id_fk"
  add_foreign_key "stocks", "passwords", name: "stocks_password_id_fk"
  add_foreign_key "stories", "identities"
  add_foreign_key "story_pictures", "identities"
  add_foreign_key "story_pictures", "identity_files"
  add_foreign_key "story_pictures", "stories"
  add_foreign_key "sun_exposures", "identities", name: "sun_exposures_identity_id_fk"
  add_foreign_key "surgeries", "doctors"
  add_foreign_key "surgeries", "identities"
  add_foreign_key "surgeries", "locations", column: "hospital_id"
  add_foreign_key "surgery_files", "identities"
  add_foreign_key "surgery_files", "identity_files"
  add_foreign_key "surgery_files", "surgeries"
  add_foreign_key "tax_document_files", "identities"
  add_foreign_key "tax_document_files", "identity_files"
  add_foreign_key "tax_document_files", "tax_documents"
  add_foreign_key "tax_documents", "identities"
  add_foreign_key "temperatures", "identities", name: "temperatures_identity_id_fk"
  add_foreign_key "test_object_files", "identities"
  add_foreign_key "test_object_files", "identity_files"
  add_foreign_key "test_object_files", "test_objects"
  add_foreign_key "test_object_instance_files", "identities"
  add_foreign_key "test_object_instance_files", "identity_files"
  add_foreign_key "test_object_instance_files", "test_object_instances"
  add_foreign_key "test_object_instances", "identities"
  add_foreign_key "test_object_instances", "test_objects"
  add_foreign_key "test_objects", "contacts"
  add_foreign_key "test_objects", "identities"
  add_foreign_key "test_score_files", "identities"
  add_foreign_key "test_score_files", "identity_files"
  add_foreign_key "test_score_files", "test_scores"
  add_foreign_key "test_scores", "identities"
  add_foreign_key "text_message_contacts", "contacts"
  add_foreign_key "text_message_contacts", "identities"
  add_foreign_key "text_message_contacts", "text_messages"
  add_foreign_key "text_message_groups", "groups"
  add_foreign_key "text_message_groups", "identities"
  add_foreign_key "text_message_groups", "text_messages"
  add_foreign_key "text_message_tokens", "identities"
  add_foreign_key "text_message_unsubscriptions", "identities"
  add_foreign_key "text_messages", "identities"
  add_foreign_key "therapists", "contacts", name: "therapists_contact_id_fk"
  add_foreign_key "therapists", "identities", name: "therapists_identity_id_fk"
  add_foreign_key "timing_events", "identities"
  add_foreign_key "timing_events", "timings"
  add_foreign_key "timings", "identities"
  add_foreign_key "to_dos", "identities", name: "to_dos_identity_id_fk"
  add_foreign_key "trek_pictures", "identities"
  add_foreign_key "trek_pictures", "identity_files"
  add_foreign_key "trek_pictures", "treks"
  add_foreign_key "treks", "identities"
  add_foreign_key "treks", "locations"
  add_foreign_key "trip_flights", "flights"
  add_foreign_key "trip_flights", "identities"
  add_foreign_key "trip_flights", "trips"
  add_foreign_key "trip_pictures", "identities", name: "trip_pictures_identity_id_fk"
  add_foreign_key "trip_pictures", "identity_files", name: "trip_pictures_identity_file_id_fk"
  add_foreign_key "trip_pictures", "trips", name: "trip_pictures_trip_id_fk"
  add_foreign_key "trip_stories", "identities"
  add_foreign_key "trip_stories", "stories"
  add_foreign_key "trip_stories", "trips"
  add_foreign_key "trips", "hotels"
  add_foreign_key "trips", "identities", name: "trips_identity_id_fk"
  add_foreign_key "trips", "identity_files"
  add_foreign_key "trips", "locations", name: "trips_location_id_fk"
  add_foreign_key "tv_shows", "contacts", column: "recommender_id"
  add_foreign_key "tv_shows", "identities"
  add_foreign_key "user_capabilities", "identities"
  add_foreign_key "users", "identities", column: "primary_identity_id", name: "users_primary_identity_id_fk"
  add_foreign_key "vaccine_files", "identities"
  add_foreign_key "vaccine_files", "identity_files"
  add_foreign_key "vaccine_files", "vaccines"
  add_foreign_key "vaccines", "identities"
  add_foreign_key "vehicle_insurances", "companies", name: "vehicle_insurances_company_id_fk"
  add_foreign_key "vehicle_insurances", "identities", name: "vehicle_insurances_identity_id_fk"
  add_foreign_key "vehicle_insurances", "periodic_payments", name: "vehicle_insurances_periodic_payment_id_fk"
  add_foreign_key "vehicle_insurances", "vehicles", name: "vehicle_insurances_vehicle_id_fk"
  add_foreign_key "vehicle_loans", "identities", name: "vehicle_loans_identity_id_fk"
  add_foreign_key "vehicle_loans", "loans", name: "vehicle_loans_loan_id_fk"
  add_foreign_key "vehicle_loans", "vehicles", name: "vehicle_loans_vehicle_id_fk"
  add_foreign_key "vehicle_pictures", "identities", name: "vehicle_pictures_identity_id_fk"
  add_foreign_key "vehicle_pictures", "identity_files", name: "vehicle_pictures_identity_file_id_fk"
  add_foreign_key "vehicle_pictures", "vehicles", name: "vehicle_pictures_vehicle_id_fk"
  add_foreign_key "vehicle_registration_files", "identities"
  add_foreign_key "vehicle_registration_files", "identity_files"
  add_foreign_key "vehicle_registration_files", "vehicle_registrations"
  add_foreign_key "vehicle_registrations", "identities"
  add_foreign_key "vehicle_registrations", "vehicles"
  add_foreign_key "vehicle_service_files", "identities"
  add_foreign_key "vehicle_service_files", "identity_files"
  add_foreign_key "vehicle_service_files", "vehicle_services"
  add_foreign_key "vehicle_services", "identities", name: "vehicle_services_identity_id_fk"
  add_foreign_key "vehicle_services", "vehicles", name: "vehicle_services_vehicle_id_fk"
  add_foreign_key "vehicle_warranties", "identities", name: "vehicle_warranties_identity_id_fk"
  add_foreign_key "vehicle_warranties", "vehicles", name: "vehicle_warranties_vehicle_id_fk"
  add_foreign_key "vehicle_warranties", "warranties", name: "vehicle_warranties_warranty_id_fk"
  add_foreign_key "vehicles", "identities", name: "vehicles_identity_id_fk"
  add_foreign_key "vehicles", "recreational_vehicles", name: "vehicles_recreational_vehicle_id_fk"
  add_foreign_key "vitamin_ingredients", "identities", name: "vitamin_ingredients_identity_id_fk"
  add_foreign_key "vitamin_ingredients", "vitamins", column: "parent_vitamin_id", name: "vitamin_ingredients_parent_vitamin_id_fk"
  add_foreign_key "vitamin_ingredients", "vitamins", name: "vitamin_ingredients_vitamin_id_fk"
  add_foreign_key "vitamins", "identities", name: "vitamins_identity_id_fk"
  add_foreign_key "volunteering_activities", "identities"
  add_foreign_key "warranties", "identities", name: "warranties_identity_id_fk"
  add_foreign_key "web_comics", "feeds"
  add_foreign_key "web_comics", "identities"
  add_foreign_key "web_comics", "websites"
  add_foreign_key "website_domain_registrations", "identities"
  add_foreign_key "website_domain_registrations", "periodic_payments"
  add_foreign_key "website_domain_registrations", "repeats"
  add_foreign_key "website_domain_registrations", "website_domains"
  add_foreign_key "website_domain_ssh_keys", "identities"
  add_foreign_key "website_domain_ssh_keys", "ssh_keys"
  add_foreign_key "website_domain_ssh_keys", "website_domains"
  add_foreign_key "website_domains", "identities"
  add_foreign_key "website_domains", "identity_files", column: "default_header_icon_identity_file_id"
  add_foreign_key "website_domains", "identity_files", column: "favicon_ico_identity_file_id"
  add_foreign_key "website_domains", "identity_files", column: "favicon_png_identity_file_id"
  add_foreign_key "website_domains", "memberships", column: "domain_host_id"
  add_foreign_key "website_domains", "websites"
  add_foreign_key "website_list_items", "identities"
  add_foreign_key "website_list_items", "website_lists"
  add_foreign_key "website_list_items", "websites"
  add_foreign_key "website_lists", "identities"
  add_foreign_key "website_passwords", "identities"
  add_foreign_key "website_passwords", "passwords"
  add_foreign_key "website_passwords", "websites"
  add_foreign_key "website_scraper_transformations", "identities"
  add_foreign_key "website_scraper_transformations", "website_scrapers"
  add_foreign_key "website_scrapers", "identities"
  add_foreign_key "websites", "contacts", column: "recommender_id"
  add_foreign_key "websites", "identities", name: "websites_identity_id_fk"
  add_foreign_key "weights", "identities", name: "weights_identity_id_fk"
  add_foreign_key "wisdom_files", "identities"
  add_foreign_key "wisdom_files", "identity_files"
  add_foreign_key "wisdom_files", "wisdoms"
  add_foreign_key "wisdoms", "identities", name: "wisdoms_identity_id_fk"
end
