Category.create!([
  {id: 1, name: "order", link: "order", position: 2, parent_id: nil, additional_filtertext: nil, icon: "famfamfam/bricks.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 2, name: "joy", link: "joy", position: 0, parent_id: nil, additional_filtertext: nil, icon: "famfamfam/emoticon_smile.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 3, name: "meaning", link: "meaning", position: 1, parent_id: nil, additional_filtertext: nil, icon: "famfamfam/lightbulb.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 4, name: "passwords", link: "passwords", position: 0, parent_id: 1, additional_filtertext: "websites", icon: "famfamfam/textfield_key.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 5, name: "movies", link: "movies", position: 0, parent_id: 2, additional_filtertext: nil, icon: "famfamfam/film.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 6, name: "wisdoms", link: "wisdoms", position: 0, parent_id: 3, additional_filtertext: "learn", icon: "FatCow_Icons16x16/brain.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 7, name: "to_dos", link: "to_dos", position: 0, parent_id: 1, additional_filtertext: "to dos reminder", icon: "famfamfam/calendar.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 8, name: "contacts", link: "contacts", position: 0, parent_id: 1, additional_filtertext: "birthdays", icon: "famfamfam/user.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 9, name: "files", link: "files", position: 0, parent_id: 1, additional_filtertext: "pictures images gifs", icon: "famfamfam/attach.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 10, name: "accomplishments", link: "accomplishments", position: 0, parent_id: 3, additional_filtertext: nil, icon: "famfamfam/award_star_gold_1.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 11, name: "feeds", link: "feeds", position: 0, parent_id: 1, additional_filtertext: "rss atom", icon: "famfamfam/feed.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 12, name: "locations", link: "locations", position: 0, parent_id: 1, additional_filtertext: "addresses", icon: "famfamfam/map.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 13, name: "activities", link: "activities", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/direction.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 14, name: "apartments", link: "apartments", position: 0, parent_id: 1, additional_filtertext: "addresses", icon: "famfamfam/house.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 15, name: "jokes", link: "jokes", position: 0, parent_id: 2, additional_filtertext: nil, icon: "famfamfam/emoticon_tongue.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 16, name: "companies", link: "companies", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/building.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 17, name: "promises", link: "promises", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/asterisk_orange.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 18, name: "memberships", link: "memberships", position: 0, parent_id: 1, additional_filtertext: "subscriptions", icon: "FatCow_Icons16x16/protect_share_workbook.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 19, name: "credit_scores", link: "credit_scores", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/table_money.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 20, name: "websites", link: "websites", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/page_world.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 21, name: "credit_cards", link: "credit_cards", position: 0, parent_id: 1, additional_filtertext: "debit", icon: "famfamfam/creditcards.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 22, name: "bank_accounts", link: "bank_accounts", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/bank.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 23, name: "ideas", link: "ideas", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/lightning.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 24, name: "lists", link: "lists", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/note.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 25, name: "calculation_forms", link: "calculation_forms", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/calculator.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 26, name: "calculations", link: "calculations", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/calculator_add.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 27, name: "vehicles", link: "vehicles", position: 0, parent_id: 1, additional_filtertext: "cars truck", icon: "famfamfam/car.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 28, name: "questions", link: "questions", position: 0, parent_id: 3, additional_filtertext: nil, icon: "famfamfam/help.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 29, name: "health", link: "health", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/health.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 30, name: "weights", link: "weights", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/weighing_mashine.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 31, name: "blood_pressures", link: "blood_pressures", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/celsius.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 32, name: "heart_rates", link: "heart_rates", position: 0, parent_id: 29, additional_filtertext: "pulse", icon: "FatCow_Icons16x16/heart.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 33, name: "recipes", link: "recipes", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/chefs_hat.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 34, name: "sleep_measurements", link: "sleep_measurements", position: 0, parent_id: 29, additional_filtertext: nil, icon: "famfamfam/status_away.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 35, name: "heights", link: "heights", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/ruler.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 36, name: "meals", link: "meals", position: 0, parent_id: 29, additional_filtertext: "snacks", icon: "FatCow_Icons16x16/omelet.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 37, name: "recreational_vehicles", link: "recreational_vehicles", position: 0, parent_id: 1, additional_filtertext: "rvs campers", icon: "famfamfam/lorry.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 38, name: "acne_measurements", link: "acne_measurements", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/bubblechart_red.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 39, name: "exercises", link: "exercises", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/shoe.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 40, name: "sun_exposures", link: "sun_exposures", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/weather_sun.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 41, name: "medicine_usages", link: "medicine_usages", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/injection.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 42, name: "pains", link: "pains", position: 0, parent_id: 29, additional_filtertext: "health medical problem issue condition pain", icon: "FatCow_Icons16x16/fire.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 43, name: "songs", link: "songs", position: 0, parent_id: 2, additional_filtertext: "music", icon: "FatCow_Icons16x16/music.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 44, name: "blood_tests", link: "blood_tests", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/injection_red.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 45, name: "checklists", link: "checklists", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/check_boxes.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 46, name: "medical_conditions", link: "medical_conditions", position: 0, parent_id: 29, additional_filtertext: "health medical problem issue condition pain", icon: "FatCow_Icons16x16/medical_record.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 47, name: "life_goals", link: "life_goals", position: 0, parent_id: 3, additional_filtertext: "intentions do desire", icon: "FatCow_Icons16x16/compass.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 48, name: "temperatures", link: "temperatures", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/temperature_warm.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 49, name: "headaches", link: "headaches", position: 0, parent_id: 29, additional_filtertext: "health medical problem issue condition pain", icon: "FatCow_Icons16x16/emotion_fire.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 50, name: "skin_treatments", link: "skin_treatments", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/user_nude.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 51, name: "finance", link: "finance", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/coins.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 52, name: "periodic_payments", link: "periodic_payments", position: 0, parent_id: 51, additional_filtertext: "recurring", icon: "FatCow_Icons16x16/table_money.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 53, name: "jobs", link: "jobs", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/reseller_account.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 54, name: "trips", link: "trips", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/location_pin.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 55, name: "passports", link: "passports", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/change_language.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 56, name: "promotions", link: "promotions", position: 0, parent_id: 51, additional_filtertext: "coupons gifts vouchers credits discounts", icon: "FatCow_Icons16x16/coins_in_hand.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 57, name: "reward_programs", link: "reward_programs", position: 0, parent_id: 51, additional_filtertext: "loyalty", icon: "FatCow_Icons16x16/teddy_bear.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 58, name: "computers", link: "computers", position: 0, parent_id: 1, additional_filtertext: "laptops servers", icon: "FatCow_Icons16x16/laptop.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 59, name: "life_insurances", link: "life_insurances", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/skull_old.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 60, name: "diary_entries", link: "diary_entries", position: 0, parent_id: 3, additional_filtertext: nil, icon: "FatCow_Icons16x16/report.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 61, name: "restaurants", link: "restaurants", position: 0, parent_id: 2, additional_filtertext: "bars dessert", icon: "FatCow_Icons16x16/cutleries.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 62, name: "camp_locations", link: "camp_locations", position: 0, parent_id: 2, additional_filtertext: "boondocking", icon: "FatCow_Icons16x16/tree.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 63, name: "guns", link: "guns", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/gun.png", explicit: true, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 64, name: "desired_products", link: "desired_products", position: 0, parent_id: 1, additional_filtertext: "buy purchase things", icon: "FatCow_Icons16x16/cart.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 65, name: "books", link: "books", position: 0, parent_id: 2, additional_filtertext: "comics", icon: "FatCow_Icons16x16/book.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 66, name: "favorite_products", link: "favorite_products", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/star.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 67, name: "therapists", link: "therapists", position: 0, parent_id: 3, additional_filtertext: nil, icon: "FatCow_Icons16x16/account_functions.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 68, name: "health_insurances", link: "health_insurances", position: 0, parent_id: 29, additional_filtertext: "medical", icon: "FatCow_Icons16x16/support.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 69, name: "random", link: "random", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/dice.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 70, name: "doctors", link: "doctors", position: 0, parent_id: 29, additional_filtertext: "dentists", icon: "FatCow_Icons16x16/user_medical.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 71, name: "dental_insurances", link: "dental_insurances", position: 0, parent_id: 29, additional_filtertext: "health medical", icon: "FatCow_Icons16x16/tooth.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 72, name: "hobbies", link: "hobbies", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/paper_airplane.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 73, name: "poems", link: "poems", position: 0, parent_id: 3, additional_filtertext: "poetry", icon: "FatCow_Icons16x16/quill.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 74, name: "musical_groups", link: "musical_groups", position: 0, parent_id: 2, additional_filtertext: "musicians artists singers", icon: "FatCow_Icons16x16/theater.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 75, name: "users", link: "users", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/group.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 76, name: "dentist_visits", link: "dentist_visits", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/tooth.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 77, name: "doctor_visits", link: "doctor_visits", position: 0, parent_id: 29, additional_filtertext: "health medical problem issue condition pain", icon: "FatCow_Icons16x16/bandaid.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 78, name: "statuses", link: "statuses", position: 0, parent_id: 3, additional_filtertext: nil, icon: "FatCow_Icons16x16/emotion_draw.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 79, name: "notepads", link: "notepads", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/note.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 80, name: "concerts", link: "concerts", position: 0, parent_id: 2, additional_filtertext: "music", icon: "FatCow_Icons16x16/speakers.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 81, name: "shopping_lists", link: "shopping_lists", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/cart_put.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 82, name: "tools", link: "tools", position: 0, parent_id: 1, additional_filtertext: "gps", icon: "famfamfam/wrench.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 83, name: "groups", link: "groups", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/group.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 84, name: "phones", link: "phones", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/phone.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 85, name: "movie_theaters", link: "movie_theaters", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/movies.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 86, name: "gas_stations", link: "gas_stations", position: 0, parent_id: 1, additional_filtertext: "propane diesel fillup rv dump", icon: "FatCow_Icons16x16/gas.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 87, name: "events", link: "events", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/calendar_view_day.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 88, name: "stocks", link: "stocks", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/finance.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 89, name: "museums", link: "museums", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/cup_gold.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 90, name: "date_locations", link: "date_locations", position: 0, parent_id: 2, additional_filtertext: "dates", icon: "FatCow_Icons16x16/heart.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 91, name: "playlists", link: "playlists", position: 0, parent_id: 2, additional_filtertext: "music", icon: "FatCow_Icons16x16/ear_listen.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 92, name: "bars", link: "bars", position: 0, parent_id: 2, additional_filtertext: "restaurants", icon: "FatCow_Icons16x16/glass_of_wine_full.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 93, name: "treks", link: "treks", position: 0, parent_id: 2, additional_filtertext: "hikes", icon: "FatCow_Icons16x16/tree.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 94, name: "money_balances", link: "money_balances", position: 0, parent_id: 51, additional_filtertext: "lend owe rent pay paid", icon: "FatCow_Icons16x16/blackboard_sum.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 95, name: "permissions", link: "permissions", position: 0, parent_id: 1, additional_filtertext: "share", icon: "FatCow_Icons16x16/lock.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 96, name: "receipts", link: "receipts", position: 0, parent_id: 51, additional_filtertext: "orders purchases", icon: "FatCow_Icons16x16/receipt.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 97, name: "stories", link: "stories", position: 0, parent_id: 3, additional_filtertext: "what doing new happening", icon: "FatCow_Icons16x16/system_monitor.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 98, name: "dessert_locations", link: "dessert_locations", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/piece_of_cake.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 99, name: "desired_locations", link: "desired_locations", position: 0, parent_id: 2, additional_filtertext: "places go", icon: "FatCow_Icons16x16/map_magnify.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 100, name: "book_stores", link: "book_stores", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/bookshelf.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 101, name: "volunteering_activities", link: "volunteering_activities", position: 0, parent_id: 3, additional_filtertext: "intentions non-profit good do mentor donate", icon: "FatCow_Icons16x16/share.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 102, name: "happy_things", link: "happy_things", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/teddy_bear.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 103, name: "annuities", link: "annuities", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/credit.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 104, name: "podcasts", link: "podcasts", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/ipod_cast.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 105, name: "hotels", link: "hotels", position: 0, parent_id: 1, additional_filtertext: nil, icon: "famfamfam/building.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 106, name: "emails", link: "emails", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/email.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 107, name: "obscure", link: "obscure", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/donut.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: nil},
  {id: 108, name: "drafts", link: "drafts", position: 0, parent_id: 107, additional_filtertext: nil, icon: "FatCow_Icons16x16/draft.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 109, name: "awesome_lists", link: "awesome_lists", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/emotion_grin.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 110, name: "ssh_keys", link: "ssh_keys", position: 0, parent_id: 107, additional_filtertext: nil, icon: "FatCow_Icons16x16/ssh_shell_access.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 112, name: "cafes", link: "cafes", position: 0, parent_id: 2, additional_filtertext: "coffee shop cafe", icon: "FatCow_Icons16x16/cup.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 113, name: "charities", link: "charities", position: 0, parent_id: 3, additional_filtertext: "non profit volunteer help foundation gift philanthropy donate", icon: "FatCow_Icons16x16/support.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 114, name: "quests", link: "quests", position: 0, parent_id: 3, additional_filtertext: "learn education analysis exploration inquiry investigation probe experiment", icon: "FatCow_Icons16x16/magnifier.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 115, name: "timings", link: "timings", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/time.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 116, name: "emergency_contacts", link: "emergency_contacts", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/life_vest.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 117, name: "tv_shows", link: "tv_shows", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/television.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 118, name: "website_domains", link: "website_domains", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/domain_names_advanced.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 119, name: "bets", link: "bets", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/chess_horse.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 120, name: "meadows", link: "meadows", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/butterfly.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 121, name: "web_comics", link: "web_comics", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/stickman.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 122, name: "projects", link: "projects", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/hammer.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 123, name: "flights", link: "flights", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/plane.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 124, name: "text_messages", link: "text_messages", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/phone_sound.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 125, name: "business_cards", link: "business_cards", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/vcard.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 126, name: "problem_reports", link: "problem_reports", position: 0, parent_id: 1, additional_filtertext: "complaint concern incident observation warning feedback suggestion bug issue", icon: "FatCow_Icons16x16/exclamation.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 127, name: "connections", link: "connections", position: 0, parent_id: 3, additional_filtertext: "friends relationships", icon: "FatCow_Icons16x16/users_men_women.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 128, name: "myreferences", link: "myreferences", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/client_account_template.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 129, name: "dreams", link: "dreams", position: 0, parent_id: 3, additional_filtertext: nil, icon: "FatCow_Icons16x16/brain_trainer.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 130, name: "messages", link: "messages", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/envelopes.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 131, name: "media_dumps", link: "media_dumps", position: 0, parent_id: 2, additional_filtertext: "music memes", icon: "FatCow_Icons16x16/bin_empty.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 132, name: "website_lists", link: "website_lists", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/domain_template.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 133, name: "exercise_regimens", link: "exercise_regimens", position: 0, parent_id: 29, additional_filtertext: "workouts", icon: "FatCow_Icons16x16/walk.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 134, name: "favorite_locations", link: "favorite_locations", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/earth_night.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 135, name: "life_highlights", link: "life_highlights", position: 0, parent_id: 3, additional_filtertext: nil, icon: "famfamfam/newspaper.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 136, name: "educations", link: "educations", position: 0, parent_id: 1, additional_filtertext: "school collegeis high elementary schools", icon: "FatCow_Icons16x16/education.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 137, name: "email_accounts", link: "email_accounts", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/email_accounts.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 138, name: "documents", link: "documents", position: 0, parent_id: 1, additional_filtertext: "important", icon: "FatCow_Icons16x16/document_black.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 139, name: "retirement_plans", link: "retirement_plans", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/financial_functions.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 140, name: "perishable_foods", link: "perishable_foods", position: 0, parent_id: 1, additional_filtertext: "canned", icon: "FatCow_Icons16x16/spam.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 141, name: "foods", link: "foods", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/chinese_noodles.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 142, name: "items", link: "items", position: 0, parent_id: 1, additional_filtertext: "property things", icon: "FatCow_Icons16x16/rubber_duck.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 143, name: "vaccines", link: "vaccines", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/injection.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 144, name: "test_objects", link: "test_objects", position: 0, parent_id: 107, additional_filtertext: nil, icon: "FatCow_Icons16x16/trojan_horse.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 145, name: "tax_documents", link: "tax_documents", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/table_money.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 146, name: "quotes", link: "quotes", position: 0, parent_id: 3, additional_filtertext: nil, icon: "FatCow_Icons16x16/document_quote.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 147, name: "prescriptions", link: "prescriptions", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/document_yellow.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 148, name: "donations", link: "donations", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/coins_in_hand.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 149, name: "checks", link: "checks", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/cheque.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 150, name: "test_scores", link: "test_scores", position: 0, parent_id: 1, additional_filtertext: "SAT", icon: "FatCow_Icons16x16/application_edit.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 151, name: "bills", link: "bills", position: 0, parent_id: 51, additional_filtertext: "invoices", icon: "FatCow_Icons16x16/document_info.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 152, name: "patents", link: "patents", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/document_protect.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 153, name: "dating_profiles", link: "dating_profiles", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/personals.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 154, name: "memories", link: "memories", position: 0, parent_id: 3, additional_filtertext: nil, icon: "FatCow_Icons16x16/flashlight_shine.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 155, name: "software_licenses", link: "software_licenses", position: 0, parent_id: 1, additional_filtertext: "", icon: "FatCow_Icons16x16/license_key.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 156, name: "music_albums", link: "music_albums", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/cd_case.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 157, name: "surgeries", link: "surgeries", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/scalpel.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 158, name: "injuries", link: "injuries", position: 0, parent_id: 29, additional_filtertext: "health medical problem issue condition pain", icon: "FatCow_Icons16x16/fire.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 159, name: "driver_licenses", link: "driver_licenses", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/form_photo.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 160, name: "hospital_visits", link: "hospital_visits", position: 0, parent_id: 29, additional_filtertext: "health medical problem issue condition pain", icon: "FatCow_Icons16x16/stethoscope.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 161, name: "paid_taxes", link: "paid_taxes", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/money.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 162, name: "psychological_evaluations", link: "psychological_evaluations", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/emotion_detective.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 163, name: "insurance_cards", link: "insurance_cards", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/infocard.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 164, name: "sicknesses", link: "sicknesses", position: 0, parent_id: 29, additional_filtertext: "cold fever health medical problem issue condition pain", icon: "FatCow_Icons16x16/emotion_sick.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 165, name: "picnic_locations", link: "picnic_locations", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/grass.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 166, name: "user_capabilities", link: "user_capabilities", position: 0, parent_id: 107, additional_filtertext: nil, icon: "FatCow_Icons16x16/user_ninja.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 167, name: "website_scrapers", link: "website_scrapers", position: 0, parent_id: 107, additional_filtertext: nil, icon: "FatCow_Icons16x16/domain_template.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 168, name: "regimens", link: "regimens", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/cargo.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 169, name: "dietary_requirements_collections", link: "dietary_requirements_collections", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/tubes.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 170, name: "dietary_requirements", link: "dietary_requirements", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/show_accounts_over_quota.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 171, name: "diets", link: "diets", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/omelet.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 172, name: "consumed_foods", link: "consumed_foods", position: 0, parent_id: 29, additional_filtertext: "eat breakfast lunch dinner snack meals", icon: "FatCow_Icons16x16/omelet.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 173, name: "nutrients", link: "nutrients", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/node.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 174, name: "beaches", link: "beaches", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/weather_sun.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 175, name: "imports", link: "imports", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/text_imports.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 176, name: "blogs", link: "blogs", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/blogs.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 177, name: "translations", link: "translations", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/translation_tool_tip.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 178, name: "boycotts", link: "boycotts", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/cart_error.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 179, name: "reminders", link: "reminders", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/time.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 180, name: "point_displays", link: "point_displays", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/check_box_uncheck.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: true},
  {id: 181, name: "myplaceonline_searches", link: "myplaceonline_searches", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/check_box_uncheck.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: true},
  {id: 182, name: "myplaceonline_quick_category_displays", link: "myplaceonline_quick_category_displays", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/check_box_uncheck.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: true},
  {id: 183, name: "calendars", link: "calendars", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/check_box_uncheck.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: true},
  {id: 184, name: "dna_analyses", link: "dna_analyses", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/molecule.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 185, name: "internal_contents", link: "internal_contents", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/check_box_uncheck.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: true, internal: true},
  {id: 186, name: "reputation_reports", link: "reputation_reports", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/lighthouse.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 187, name: "agents", link: "agents", position: 1, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/account_menu.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 188, name: "site_invoices", link: "site_invoices", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/receipt_invoice.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: true},
  {id: 189, name: "computer_environments", link: "computer_environments", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/server.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 190, name: "food_lists", link: "food_lists", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/text_list_numbers.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 191, name: "security_tokens", link: "security_tokens", position: 0, parent_id: 1, additional_filtertext: "api", icon: "FatCow_Icons16x16/security.png", explicit: nil, user_type_mask: nil, experimental: true, simple: nil, internal: nil},
  {id: 192, name: "exports", link: "exports", position: 0, parent_id: 1, additional_filtertext: "backup offline archive save", icon: "FatCow_Icons16x16/saved_exports.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 193, name: "wallets", link: "wallets", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/wallet.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 194, name: "financial_assets", link: "financial_assets", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/moneybox.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 195, name: "boondockings", link: "boondockings", position: 0, parent_id: 2, additional_filtertext: "camping overnight location", icon: "FatCow_Icons16x16/tree_red.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 196, name: "allergies", link: "allergies", position: 0, parent_id: 29, additional_filtertext: "health medical problem issue condition pain", icon: "FatCow_Icons16x16/emotion_sweat.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 197, name: "saved_games", link: "saved_games", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/layer_save.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 198, name: "drinks", link: "drinks", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/glass_of_wine_empty.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 199, name: "research_papers", link: "research_papers", position: 0, parent_id: 3, additional_filtertext: nil, icon: "FatCow_Icons16x16/research.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 200, name: "presents", link: "presents", position: 0, parent_id: 2, additional_filtertext: "birthday cards gifts", icon: "FatCow_Icons16x16/card_gift_2.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 201, name: "quizzes", link: "quizzes", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/question.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 202, name: "drink_lists", link: "drink_lists", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/page_white_cup.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 203, name: "credit_reports", link: "credit_reports", position: 0, parent_id: 51, additional_filtertext: nil, icon: "FatCow_Icons16x16/report_magnify.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 204, name: "arts", link: "arts", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/palette.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 205, name: "parking_locations", link: "parking_locations", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/car.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 206, name: "dealbreakers", link: "drom_match/dealbreakers", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/heart_half.png", explicit: nil, user_type_mask: 1, experimental: nil, simple: nil, internal: nil},
  {id: 207, name: "videos", link: "videos", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/video.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 208, name: "notifications", link: "notifications", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/mail_box.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 209, name: "notification_preferences", link: "notification_preferences", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/email_setting.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 210, name: "hospitals", link: "hospitals", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/hospital.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 211, name: "crontabs", link: "crontabs", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/time.png", explicit: nil, user_type_mask: 1, experimental: nil, simple: nil, internal: nil},
  {id: 212, name: "vehicle_washes", link: "vehicle_washes", position: 0, parent_id: 1, additional_filtertext: "cars rvs trucks recreational", icon: "FatCow_Icons16x16/broom.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 213, name: "dealbreaker_relationships", link: "drom_match/dealbreaker_relationships", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/connect.png", explicit: nil, user_type_mask: 1, experimental: nil, simple: nil, internal: nil},
  {id: 214, name: "haircuts", link: "haircuts", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/cut.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 215, name: "mechanics", link: "mechanics", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/construction.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 216, name: "wireless_networks", link: "wireless_networks", position: 0, parent_id: 1, additional_filtertext: "wifi", icon: "FatCow_Icons16x16/wi_fi.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 217, name: "mrobbles", link: "mrobbles", position: 0, parent_id: 2, additional_filtertext: "scrobble video audio podcast mp3 media", icon: "FatCow_Icons16x16/sound_wave.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 218, name: "parks", link: "parks", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/tree.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 219, name: "basketball_courts", link: "basketball_courts", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/sport_basketball.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 220, name: "tennis_courts", link: "tennis_courts", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/sport_tennis.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 221, name: "soccer_fields", link: "soccer_fields", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/sport_soccer.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 222, name: "health_changes", link: "health_changes", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/report_user.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 223, name: "medicines", link: "medicines", position: 0, parent_id: 29, additional_filtertext: nil, icon: "FatCow_Icons16x16/pill.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 224, name: "warranties", link: "warranties", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/license_management.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 225, name: "cities", link: "drom_match/cities", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/building.png", explicit: nil, user_type_mask: 1, experimental: nil, simple: nil, internal: nil},
  {id: 226, name: "city_regions", link: "drom_match/city_regions", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/building.png", explicit: nil, user_type_mask: 1, experimental: nil, simple: nil, internal: nil},
  {id: 227, name: "airline_programs", link: "airline_programs", position: 0, parent_id: 1, additional_filtertext: "flights rewards points", icon: "FatCow_Icons16x16/plane.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 228, name: "locks", link: "locks", position: 0, parent_id: 1, additional_filtertext: nil, icon: "FatCow_Icons16x16/lock.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 229, name: "memes", link: "memes", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/user_wicket.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 230, name: "gift_stores", link: "gift_stores", position: 0, parent_id: 2, additional_filtertext: "cabinet curiosity curiosities antique macabre morbid interesting present", icon: "FatCow_Icons16x16/gift_add.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 231, name: "barbecues", link: "barbecues", position: 0, parent_id: 2, additional_filtertext: "restaurant food bbq", icon: "FatCow_Icons16x16/steak_meat.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil},
  {id: 232, name: "restaurant_dishes", link: "restaurant_dishes", position: 0, parent_id: 2, additional_filtertext: nil, icon: "FatCow_Icons16x16/dish.png", explicit: nil, user_type_mask: nil, experimental: nil, simple: nil, internal: nil}
])

# Reinitialize to cache the categories created above
Myp.reinitialize

Rails.logger.info{"Loading seeds started"}

user = User.new
user.id = User::SUPER_USER_ID
user.email = "root@myplaceonline.com" # Generated from ENV["ROOT_EMAIL"]
user.password = "password" # Generated from ENV["ROOT_PASSWORD"]
user.password_confirmation = user.password
user.confirmed_at = Time.now
user.user_type = User::USER_TYPE_ADMIN
user.explicit_categories = true
user.experimental_categories = true
user.save(validate: false)

MyplaceonlineExecutionContext.do_user(user) do

  identity = Identity.new
  identity.id = User::SUPER_USER_IDENTITY_ID
  identity.user_id = User::SUPER_USER_ID
  identity.name = "root"
  identity.website_domain_default = true
  identity.save(validate: false)

  # We just need a temporary object that points to the identity we just created
  MyplaceonlineExecutionContext.do_permission_target(Identity.new(identity: identity)) do
    if ENV["SKIP_LARGE_UNNEEDED_IMPORTS"].nil?
      Myp.import_museums
    end

    if ENV["SKIP_ZIP_CODE_IMPORTS"].nil?
      Myp.import_zip_codes
    end

    website_domain = Myp.create_default_website

    identity.update_column(:website_domain_id, website_domain.id)

    MyplaceonlineExecutionContext.do_identity(identity) do
      Rails.logger.info{"Seeded website domain. Reinitializing..."}

      # Reload the statically cached default domain
      Myp.reinitialize_in_rails_context

      # Reload the superuser's identities
      user.reload

      identity.after_create
    end

  end

end

Rails.logger.info{"Loading seeds completed"}

# Modifications to this file go into mypdump.rake
