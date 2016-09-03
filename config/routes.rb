Rails.application.routes.draw do
  
  resources :dreams
  post 'dreams/new'

  resources :myreferences
  post 'myreferences/new'

  get 'connections/allconnections'
  match 'connections/:id/accept', :to => 'connections#accept', via: [:get], as: "connection_accept"
  resources :connections
  post 'connections/new'

  resources :problem_reports
  post 'problem_reports/new'

  resources :business_cards
  post 'business_cards/new'

  resources :text_messages
  post 'text_messages/new'

  resources :flights
  post 'flights/new'

  match 'password_shares/:id/transfer', :to => 'password_shares#transfer', via: [:get], as: "password_shares_transfer"
  resources :password_shares
  post 'password_shares/new'
  
  match 'projects/:id/delete_by_index', :to => 'projects#delete_by_index', via: [:post], as: "project_delete_by_index"
  resources :projects do
    match 'project_issues/:id/movetop', :to => 'project_issues#movetop', via: [:get], as: "project_issues_movetop"
    resources :project_issues
    post 'project_issues/new'
  end
  post 'projects/new'
  
  resources :web_comics
  post 'web_comics/new'
  
  resources :meadows
  post 'meadows/new'
  
  resources :bets
  post 'bets/new'

  resources :website_domains
  post 'website_domains/new'

  resources :tv_shows
  post 'tv_shows/new'

  resources :emergency_contacts
  post 'emergency_contacts/new'

  resources :timings do
    resources :timing_events
    post 'timing_events/new'
  end
  post 'timings/new'

  resources :quests
  post 'quests/new'

  resources :charities
  post 'charities/new'

  resources :cafes
  post 'cafes/new'

  resources :ssh_keys
  post 'ssh_keys/new'

  resources :awesome_lists
  post 'awesome_lists/new'

  resources :drafts
  post 'drafts/new'

  get 'obscure/index'
  get 'obscure', :to => 'obscure#index'

  get 'unsubscribe/index'
  get 'unsubscribe', :to => 'unsubscribe#index'

  resources :emails
  match 'emails/:id/personalize', :to => 'emails#personalize', via: [:get, :patch], as: "emails_personalize"
  post 'emails/new'

  get 'help/index'
  get 'help/features'
  get 'help/highlights'
  get 'help/category'
  get 'help', :to => 'help#index'

  resources :permission_shares
  match 'permission_shares/:id/personalize', :to => 'permission_shares#personalize', via: [:get, :patch], as: "permission_shares_personalize"
  post 'permission_shares/new'

  resources :alerts_displays
  post 'alerts_displays/new'

  resources :hotels
  post 'hotels/new'

  resources :shares
  post 'shares/new'

  resources :podcasts
  post 'podcasts/new'

  resources :annuities
  post 'annuities/new'

  resources :happy_things
  post 'happy_things/new'

  resources :invite_codes
  post 'invite_codes/new'

  resources :volunteering_activities
  post 'volunteering_activities/new'

  resources :book_stores
  post 'book_stores/new'

  match 'calendar_item_reminder_pendings/:id/complete', :to => 'calendar_item_reminder_pendings#complete', via: [:post], as: "calendar_item_reminder_pending_complete"
  match 'calendar_item_reminder_pendings/:id/snooze', :to => 'calendar_item_reminder_pendings#snooze', via: [:post], as: "calendar_item_reminder_pending_snooze"
  resources :calendar_item_reminder_pendings
  
  resources :desired_locations
  post 'desired_locations/new'

  resources :dessert_locations
  post 'dessert_locations/new'

  resources :stories
  post 'stories/new'

  resources :receipts
  post 'receipts/new'

  match 'permissions/share', :to => 'permissions#share', via: [:get, :post], as: "permissions_share"
  match 'permissions/share_token', :to => 'permissions#share_token', via: [:get, :post], as: "permissions_share_token"
  resources :permissions
  post 'permissions/new'

  match 'money_balances/:id/add', :to => 'money_balances#add', via: [:get, :post, :patch], as: "money_balances_add"
  match 'money_balances/:id/list', :to => 'money_balances#list', via: [:get], as: "money_balances_list"
  resources :money_balances do
    resources :money_balance_item_templates
    post 'money_balance_item_templates/new'

    resources :money_balance_items
    post 'money_balance_items/new'
  end
  post 'money_balances/new'

  mount Ckeditor::Engine => '/ckeditor'
  
  resources :treks
  post 'treks/new'

  resources :bars
  post 'bars/new'

  resources :playlists
  match 'playlists/:id/share', :to => 'playlists#share', via: [:get, :post], as: "playlists_share"
  match 'playlists/:id/shared', :to => 'playlists#shared', via: [:get], as: "playlist_shared"
  post 'playlists/new'

  resources :date_locations
  post 'date_locations/new'

  resources :complete_due_items
  post 'complete_due_items/new'

  resources :snoozed_due_items
  post 'snoozed_due_items/new'

  resources :museums
  post 'museums/new'

  resources :stocks
  post 'stocks/new'

  match 'events/:id/shared', :to => 'events#shared', via: [:get], as: "event_shared"
  match 'events/:id/share', :to => 'events#share', via: [:get, :post], as: "event_share"
  match 'events/:id/rsvp', :to => 'events#rsvp', via: [:get, :post], as: "event_rsvp"
  resources :events
  post 'events/new'

  resources :gas_stations
  post 'gas_stations/new'

  resources :movie_theaters
  post 'movie_theaters/new'

  match 'due_items/:id/complete', :to => 'due_items#complete', via: [:post], as: "due_item_complete"
  match 'due_items/:id/snooze', :to => 'due_items#snooze', via: [:post], as: "due_item_snooze"
  resources :due_items
  
  resources :myplets

  resources :phones
  post 'phones/new'

  resources :groups
  post 'groups/new'
  match 'groups/:id/email_list', :to => 'groups#email_list', via: [:get], as: "groups_email_list"
  match 'groups/:id/missing_list', :to => 'groups#missing_list', via: [:get], as: "groups_missing_list"

  match 'tools/gps', via: [:get, :post]
  get 'tools/index'
  get 'tools', :to => 'tools#index'

  resources :shopping_lists
  post 'shopping_lists/new'

  resources :concerts
  post 'concerts/new'

  match 'c/:id', :to => 'calendar_item_reminder_pendings#short', via: [:get], as: "calendar_item_reminder_short"
  resources :calendars do
    resources :calendar_items do
      resources :calendar_item_reminders
    end
  end
  post 'calendars/new'

  resources :myplaceonline_quick_category_displays
  post 'myplaceonline_quick_category_displays/new'

  resources :point_displays
  post 'point_displays/new'

  resources :myplaceonline_searches
  post 'myplaceonline_searches/new'

  resources :notepads
  post 'notepads/new'

  resources :statuses
  post 'statuses/new'

  resources :doctor_visits
  post 'doctor_visits/new'

  resources :dentist_visits
  post 'dentist_visits/new'

  resources :musical_groups
  post 'musical_groups/new'

  resources :poems
  post 'poems/new'

  resources :hobbies
  post 'hobbies/new'

  resources :dental_insurances
  post 'dental_insurances/new'

  resources :doctors
  post 'doctors/new'

  match 'random/activity', via: [:get, :post]
  get 'random/index'
  get 'random', :to => 'random#index'

  resources :health_insurances
  post 'health_insurances/new'

  resources :therapists
  post 'therapists/new'

  resources :favorite_products
  post 'favorite_products/new'

  resources :warranties
  post 'warranties/new'

  resources :books
  post 'books/new'

  resources :desired_products
  post 'desired_products/new'

  resources :guns
  post 'guns/new'

  resources :camp_locations
  post 'camp_locations/new'

  resources :restaurants
  post 'restaurants/new'

  resources :diary_entries
  post 'diary_entries/new'

  resources :life_insurances
  post 'life_insurances/new'

  resources :computers
  post 'computers/new'

  resources :reward_programs
  post 'reward_programs/new'

  resources :promotions
  post 'promotions/new'

  get 'restaurants/random'
  post 'restaurants/random'

  get 'graph/source_values'
  get 'graph/display'

  resources :passports
  post 'passports/new'

  resources :trips do
    get 'trip_pictures/destroy_all'
    resources :trip_pictures
    post 'trip_pictures/new'

    resources :trip_stories
    post 'trip_stories/new'
  end
  match 'trips/:id/shared', :to => 'trips#shared', via: [:get], as: "trip_shared"
  match 'trips/:id/share', :to => 'trips#share', via: [:get, :post], as: "trip_share"
  post 'trips/new'

  resources :jobs
  post 'jobs/new'

  get 'periodic_payments/monthly_total'
  resources :periodic_payments
  post 'periodic_payments/new'

  resources :skin_treatments
  post 'skin_treatments/new'

  resources :headaches
  post 'headaches/new'

  resources :temperatures
  post 'temperatures/new'

  resources :life_goals
  post 'life_goals/new'

  resources :medical_conditions
  post 'medical_conditions/new'

  resources :checklists
  post 'checklists/new'

  resources :blood_concentrations
  post 'blood_concentrations/new'

  resources :blood_tests
  post 'blood_tests/new'

  resources :songs
  post 'songs/new'

  resources :pains
  post 'pains/new'

  resources :medicines
  post 'medicines/new'

  resources :medicine_usages
  post 'medicine_usages/new'

  resources :sun_exposures
  post 'sun_exposures/new'

  resources :exercises
  post 'exercises/new'

  resources :acne_measurements
  post 'acne_measurements/new'

  resources :recreational_vehicles
  post 'recreational_vehicles/new'

  resources :meals
  post 'meals/new'

  resources :vitamins
  post 'vitamins/new'

  resources :foods
  post 'foods/new'

  resources :drinks
  post 'drinks/new'

  resources :heights
  post 'heights/new'

  resources :sleep_measurements
  post 'sleep_measurements/new'

  resources :recipes
  post 'recipes/new'

  resources :heart_rates
  post 'heart_rates/new'

  resources :blood_pressures
  post 'blood_pressures/new'

  resources :weights
  post 'weights/new'

  resources :questions
  post 'questions/new'

  resources :vehicles
  post 'vehicles/new'

  resources :calculations
  post 'calculations/new'

  resources :calculation_forms
  post 'calculation_forms/new'

  resources :lists
  post 'lists/new'

  resources :ideas
  post 'ideas/new'

  resources :bank_accounts
  post 'bank_accounts/new'

  get 'credit_cards/total_credit'
  get 'credit_cards/listcashback'
  resources :credit_cards
  post 'credit_cards/new'

  resources :websites
  post 'websites/new'

  resources :credit_scores
  post 'credit_scores/new'

  resources :memberships
  post 'memberships/new'

  resources :promises
  post 'promises/new'

  resources :companies
  post 'companies/new'

  resources :jokes
  post 'jokes/new'

  resources :apartments
  post 'apartments/new'

  resources :activities
  post 'activities/new'

  resources :locations
  post 'locations/new'

  match 'feeds/load_all', :to => 'feeds#load_all', via: [:get], as: "feeds_load_all"
  match 'feeds/:id/load', :to => 'feeds#load', via: [:get], as: "feed_load"
  resources :feeds do
    match 'feed_items/:id/mark_read', :to => 'feed_items#mark_read', via: [:post], as: "feed_item_mark_read"
    resources :feed_items
    post 'feed_items/new'
  end
  post 'feeds/new'

  resources :accomplishments
  post 'accomplishments/new'

  match 'contacts/:id/groups', :to => 'contacts#groups', via: [:get, :post], as: "contact_groups"
  resources :contacts do
    resources :conversations
    post 'conversations/new'
  end
  post 'contacts/new'

  resources :to_dos
  post 'to_dos/new'

  resources :wisdoms
  post 'wisdoms/new'

  resources :movies
  post 'movies/new'
  
  resources :identity_files, :as => "files", :path => "files", :controller => "files"
  post 'files/new'
  match 'files/:id/rotate', :to => 'files#rotate', via: [:get, :post], as: "file_rotate"
  match 'files/:id/move', :to => 'files#move', via: [:get, :post], as: "file_move"

  match 'files/:id/view', :to => 'files#view', via: [:get], as: "file_view"
  match 'files/:id/view/:imagename', :to => 'files#view', via: [:get], as: "file_view_name"
  match 'files/:id/thumbnail', :to => 'files#thumbnail', via: [:get], as: "file_thumbnail"
  match 'files/:id/thumbnail/:imagename', :to => 'files#thumbnail', via: [:get], as: "file_thumbnail_name"
  match 'files/:id/download', :to => 'files#download', via: [:get], as: "file_download"
  match 'files/:id/download/:imagename', :to => 'files#download', via: [:get], as: "file_download_name"

  resources :identity_file_folders, :as => "file_folders", :path => "file_folders", :controller => "file_folders"
  post 'file_folders/new'

  get 'welcome/index'
  get 'api/website_title'
  get 'api/index'
  get 'api/categories'
  get 'api/search'
  get 'api/randomString'
  get 'api/subregions'
  get 'api/sleep_time'
  get 'api/hello_world'
  get 'api/newitem'
  get 'api/postal_code_search'
  post 'api/debug'
  post 'api/renderpartial'
  post 'api/quickfeedback'
  post 'api/newfile'
  get 'api/distinct_values'
  get 'api', :to => 'api#index'
  
  get 'admin/test'
  get 'admin/ensure_pending_all_users'
  get 'admin/create_test_job'

  get 'meaning/index'
  get 'meaning', :to => 'meaning#index'

  get 'order/index'
  get 'order', :to => 'order#index'

  get 'joy/index'
  get 'joy', :to => 'joy#index'

  get 'search/index'
  get 'search/show'
  get 'search', :to => 'search#index'

  get 'info/diagnostics/serverinfo', :to => 'info#serverinfo'
  get 'info/index'
  match 'info/contact', via: [:get, :post]
  get 'info/credits'
  get 'info/diagnostics'
  get 'info/sleep_time'
  get 'info/raise_server_exception'
  get 'info/faq'
  get 'info/tips'
  get 'info/about'
  get 'info/privacy'
  get 'info/terms'
  get 'info', :to => 'info#index'
  
  match 'administration/send_email', via: [:get, :post]
  match 'administration/send_text_message', via: [:get, :post]
  get 'administration/gc'
  get 'administration/index'
  get 'administration', :to => 'administration#index'

  get 'offline/index'
  get 'offline', :to => 'offline#index'
  
  match 'passwords/:id/share', :to => 'passwords#share', via: [:get, :patch, :post], as: "passwords_share"
  get 'passwords/import'
  match 'passwords/import/odf', :to => 'passwords#importodf', via: [:get, :post]
  match 'passwords/import/odf/:id/step1', :to => 'passwords#importodf1', via: [:get, :post], :as => "passwords_import_odf1"
  match 'passwords/import/odf/:id/step2', :to => 'passwords#importodf2', via: [:get, :post], :as => "passwords_import_odf2"
  match 'passwords/import/odf/:id/step3', :to => 'passwords#importodf3', via: [:get, :post], :as => "passwords_import_odf3"
  resources :passwords
  post 'passwords/new'
  get 'passwords', :to => 'passwords#index'

  get 'finance/index'
  get 'finance', :to => 'finance#index'

  get 'health/index'
  get 'health', :to => 'health#index'

  get 'test/index'
  get 'test', :to => 'test#index'
  get 'test/test1'
  get 'test/test2'
  get 'test/throw'

  get 'badges/42', :to => 'badges#n42'

  if Myp.is_web_server? || Rails.env.test?
    devise_scope :user do
      match 'users/reenter', :to => 'users/sessions#reenter', via: [:get, :post]
      post 'users/sign_up', :to => 'users/registrations#new'
      get 'users/delete', :to => 'users/registrations#delete'
      match 'users/password/change', :to => 'users/registrations#changepassword', via: [:get, :put]
      match 'users/changeemail', :to => 'users/registrations#changeemail', via: [:get, :put]
      match 'users/resetpoints', :to => 'users/registrations#resetpoints', via: [:get, :post]
      match 'users/advanced', :to => 'users/registrations#advanced', via: [:get, :post]
      match 'users/deletecategory', :to => 'users/registrations#deletecategory', via: [:get, :post]
      match 'users/appearance', :to => 'users/registrations#appearance', via: [:get, :post]
      match 'users/homepage', :to => 'users/registrations#homepage', via: [:get, :post, :patch]
      match 'users/clipboard', :to => 'users/registrations#clipboard', via: [:get, :post]
      match 'users/security', :to => 'users/registrations#security', via: [:get, :post]
      match 'users/categories', :to => 'users/registrations#categories', via: [:get, :post]
      match 'users/sounds', :to => 'users/registrations#sounds', via: [:get, :post]
      match 'users/export', :to => 'users/registrations#export', via: [:get, :post]
      match 'users/offline', :to => 'users/registrations#offline', via: [:get, :post]
      match 'users/changetimezone', :to => 'users/registrations#changetimezone', via: [:get, :post]
      match 'users/diagnostics', :to => 'users/registrations#diagnostics', via: [:get, :post]
    end

    devise_for :users, controllers: {
      confirmations: 'users/confirmations',
      #omniauth_callbacks: 'users/omniauth_callbacks',
      passwords: 'users/passwords',
      registrations: 'users/registrations',
      sessions: 'users/sessions',
      unlocks: 'users/unlocks'
    }
  end

  get 'users/allusers'
  resources :users
  post 'users/new'

  root 'welcome#index'
end
