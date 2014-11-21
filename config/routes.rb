Rails.application.routes.draw do
  get 'meaning/index'
  get 'order/index'
  get 'joy/index'
  get 'api/index'
  get 'api/categories'
  get 'search/index'
  get 'contact/index'
  get 'welcome/index'
  
  resources :passwords

  devise_scope :user do
    get "users/reenter", :to => "users/sessions#reenter", :as => "reenter"
  end

  devise_for :users, controllers: {
    registrations: 'users/registrations',
    sessions: 'users/sessions'
  }

  match '/contact', :to => 'contact#index', via: :get
  match '/search', :to => 'search#index', via: :get
  match '/joy', :to => 'joy#index', via: :get
  match '/order', :to => 'order#index', via: :get
  match '/meaning', :to => 'meaning#index', via: :get
  match '/passwords', :to => 'passwords#index', via: :get

  root 'welcome#index'
end
