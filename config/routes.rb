Rails.application.routes.draw do
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

  get 'welcome/index'
  get 'api/index'
  get 'api/categories'
  get 'api/randomString'
  get 'api/subregions'
  post 'api/renderpartial'
  post 'api/updatenotepad'
  post 'api/quickfeedback'

  get 'meaning/index'
  get 'meaning', :to => 'meaning#index'

  get 'order/index'
  get 'order', :to => 'order#index'

  get 'joy/index'
  get 'joy', :to => 'joy#index'

  get 'search/index'
  get 'search', :to => 'search#index'

  get 'info/index'
  get 'info/contact'
  get 'info/credits'
  get 'info/diagnostics'
  get 'info/faq'
  get 'info/about'
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

  get 'health/index'
  get 'health', :to => 'health#index'

  get 'test/index'
  get 'test', :to => 'test#index'
  get 'test/test1'

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
      match 'users/security', :to => 'users/registrations#security', via: [:get, :post]
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

  root 'welcome#index'
end
