Rails.application.routes.draw do
  get 'welcome/index'
  get 'api/index'
  get 'api/categories'

  get 'meaning/index'
  match 'meaning', :to => 'meaning#index', via: :get

  get 'order/index'
  match 'order', :to => 'order#index', via: :get

  get 'joy/index'
  match 'joy', :to => 'joy#index', via: :get

  get 'search/index'
  match 'search', :to => 'search#index', via: :get

  get 'contact/index'
  match 'contact', :to => 'contact#index', via: :get
  
  resources :passwords
  post 'passwords/new'
  match 'passwords', :to => 'passwords#index', via: :get

  devise_scope :user do
    match 'users/reenter', :to => 'users/sessions#reenter', via: [:get, :post]
    post 'users/sign_up', :to => 'users/registrations#new'
    get 'users/delete', :to => 'users/registrations#delete'
    match 'users/password/change', :to => 'users/registrations#changepassword', via: [:get, :put]
    match 'users/changeemail', :to => 'users/registrations#changeemail', via: [:get, :put]
    match 'users/resetpoints', :to => 'users/registrations#resetpoints', via: [:get, :post]
  end

  devise_for :users, controllers: {
    confirmations: 'users/confirmations',
    #omniauth_callbacks: 'users/omniauth_callbacks',
    passwords: 'users/passwords',
    registrations: 'users/registrations',
    sessions: 'users/sessions',
    unlocks: 'users/unlocks'
  }

  root 'welcome#index'
end
