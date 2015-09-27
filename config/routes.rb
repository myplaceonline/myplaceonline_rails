Rails.application.routes.draw do
  
  resources :phones
  post 'phones/new'

  resources :groups
  post 'groups/new'
  match 'groups/:id/email_list', :to => 'groups#email_list', via: [:get], as: "groups_email_list"

  match 'tools/gps', via: [:get, :post]
  get 'tools/index'
  get 'tools', :to => 'tools#index'

  match 'shopping_lists/:id/generate', :to => 'shopping_lists#generate', via: [:get], as: "shopping_list_generate"
  resources :shopping_lists
  post 'shopping_lists/new'

  resources :concerts
  post 'concerts/new'

  resources :myplaceonline_due_displays
  post 'myplaceonline_due_displays/new'
  get 'myplaceonline_due_displays/showmyplet'

  resources :myplaceonline_quick_category_displays
  post 'myplaceonline_quick_category_displays/new'
  get 'myplaceonline_quick_category_displays/showmyplet'

  resources :point_displays
  post 'point_displays/new'
  get 'point_displays/showmyplet'

  resources :myplaceonline_searches
  post 'myplaceonline_searches/new'

  resources :notepads
  post 'notepads/new'
  get 'notepads/showmyplet'

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

  resources :trips
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

  match 'checklists/:id/generate', :to => 'checklists#generate', via: [:get], as: "checklist_generate"
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

  resources :subscriptions
  post 'subscriptions/new'

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

  resources :feeds
  post 'feeds/new'

  resources :accomplishments
  post 'accomplishments/new'

  resources :contacts
  post 'contacts/new'

  resources :to_dos
  post 'to_dos/new'

  resources :wisdoms
  post 'wisdoms/new'

  resources :movies
  post 'movies/new'
  
  resources :identity_files, :as => "files", :path => "files", :controller => "files"
  post 'files/new'
  match 'files/:id/download', :to => 'files#download', via: [:get], as: "file_download"
  match 'files/:id/view', :to => 'files#view', via: [:get], as: "file_view"
  match 'files/:id/thumbnail', :to => 'files#thumbnail', via: [:get], as: "file_thumbnail"
  match 'files/:id/move', :to => 'files#move', via: [:get, :post], as: "file_move"

  resources :identity_file_folders, :as => "file_folders", :path => "file_folders", :controller => "file_folders"
  post 'file_folders/new'

  get 'welcome/index'
  get 'api/index'
  get 'api/categories'
  get 'api/randomString'
  get 'api/subregions'
  post 'api/renderpartial'
  post 'api/quickfeedback'

  get 'meaning/index'
  get 'meaning', :to => 'meaning#index'

  get 'order/index'
  get 'order', :to => 'order#index'

  get 'joy/index'
  get 'joy', :to => 'joy#index'

  get 'search/index'
  get 'search/show'
  get 'search', :to => 'search#index'

  get 'info/index'
  get 'info/contact'
  get 'info/credits'
  get 'info/diagnostics'
  get 'info/faq'
  get 'info/tips'
  get 'info/about'
  get 'info/privacy'
  get 'info/terms'
  get 'info', :to => 'info#index'
  
  get 'offline/index'
  get 'offline', :to => 'offline#index'
  
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
      match 'users/clipboard', :to => 'users/registrations#clipboard', via: [:get, :post]
      match 'users/security', :to => 'users/registrations#security', via: [:get, :post]
      match 'users/categories', :to => 'users/registrations#categories', via: [:get, :post]
      match 'users/export', :to => 'users/registrations#export', via: [:get, :post]
      match 'users/offline', :to => 'users/registrations#offline', via: [:get, :post]
      match 'users/changetimezone', :to => 'users/registrations#changetimezone', via: [:get, :post]
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

  resources :users
  post 'users/new'

  root 'welcome#index'
end
