def process_resources(name, context)
  #Rails.logger.debug{"process_resources name: #{name}, context: #{context.inspect}"}

  resources_as = name.to_s
  resources_path = name.to_s
  resources_controller = name.to_s
  
  if context.nil?
    context = []
  end
  
  context << { instance: true, link: "archive" }
  context << { instance: true, link: "unarchive" }
  context << { instance: true, link: "favorite" }
  context << { instance: true, link: "unfavorite" }

  context.each do |context_addition|
    if !context_addition[:instance].nil?
      if context_addition[:instance]
        match "#{resources_path}/:id/#{context_addition[:link]}", :to => "#{resources_controller}##{context_addition[:link]}", via: [:get, :post, :patch], as: "#{resources_as.to_s.singularize}_#{context_addition[:link]}"
      else
        match "#{resources_path}/#{context_addition[:link]}", :to => "#{resources_controller}##{context_addition[:link]}", via: [:get, :post], as: "#{resources_as}_#{context_addition[:link]}"
      end
    elsif !context_addition[:resourcesinfo].nil?
      if !context_addition[:as].nil?
        resources_as = context_addition[:as]
      end
      if !context_addition[:path].nil?
        resources_path = context_addition[:path]
      end
      if !context_addition[:controller].nil?
        resources_controller = context_addition[:controller]
      end
    end
  end
  
  resources name.to_sym, :as => resources_as, :path => resources_path, :controller => resources_controller do
    context.each do |context_addition|
      if !context_addition[:subresources].nil?
        process_resources(context_addition[:name], context_addition[:subitems])
      end
    end
  end
  
  post "#{name}/new"
end

def routes_index(items)
  items.each do |item|
    match "#{item}/index", via: [:get, :post]
    match "#{item}", via: [:get, :post], :to => "#{item}#index"
  end
end

def routes_get(items)
  items.each do |item|
    get item
  end
end

def routes_post(items)
  items.each do |item|
    post item
  end
end

def routes_get_post(items)
  items.each do |item|
    match "#{item}", via: [:get, :post]
  end
end

Rails.application.routes.draw do
  
  puts{"Started loading routes"}
  
  root "welcome#index"

  routes_index(%w(
    administration
    api
    finance
    health
    help
    info
    joy
    meaning
    obscure
    offline
    order
    random
    search
    test
    tools
    unsubscribe
  ))
  
  routes_get(%w(
    welcome/index
    graph/source_values
    graph/display
    api/website_title
    api/categories
    api/search
    api/randomString
    api/subregions
    api/sleep_time
    api/hello_world
    api/newitem
    api/postal_code_search
    api/distinct_values
    admin/test
    admin/ensure_pending_all_users
    admin/create_test_job
    search/show
    info/credits
    info/diagnostics
    info/sleep_time
    info/raise_server_exception
    info/faq
    info/tips
    info/about
    info/privacy
    info/terms
    administration/gc
    test/test1
    test/test2
    test/throw
    users/allusers
    help/features
    help/highlights
    help/category
  ))

  routes_post(%w(
    file_folders/new
    api/debug
    api/renderpartial
    api/quickfeedback
    api/newfile
  ))

  routes_get_post(%w(
    tools/gps
    random/activity
    info/contact
    info/invite
    administration/send_email
    administration/send_text_message
  ))

  match 'c/:id', :to => 'calendar_item_reminder_pendings#short', via: [:get], as: "calendar_item_reminder_short"

  match 'passwords/import/odf', :to => 'passwords#importodf', via: [:get, :post]
  match 'passwords/import/odf/:id/step1', :to => 'passwords#importodf1', via: [:get, :post], :as => "passwords_import_odf1"
  match 'passwords/import/odf/:id/step2', :to => 'passwords#importodf2', via: [:get, :post], :as => "passwords_import_odf2"
  match 'passwords/import/odf/:id/step3', :to => 'passwords#importodf3', via: [:get, :post], :as => "passwords_import_odf3"

  get 'info/diagnostics/checkboxes', :to => 'info#checkboxes'
  get 'info/diagnostics/serverinfo', :to => 'info#serverinfo'
  get 'info/diagnostics/clientinfo', :to => 'info#clientinfo'
  get 'info/diagnostics/jqm', :to => 'info#jqm'
  get 'badges/42', :to => 'badges#n42'

  match 'files/:id/view/:imagename', :to => 'files#view', via: [:get], as: "file_view_name"
  match 'files/:id/thumbnail/:imagename', :to => 'files#thumbnail', via: [:get], as: "file_thumbnail_name"
  match 'files/:id/download/:imagename', :to => 'files#download', via: [:get], as: "file_download_name"

  additions = {
    blood_tests: [
      { instance: false, link: "graph" }
    ],
    calendar_item_reminder_pendings: [
      { instance: true, link: "complete" },
      { instance: true, link: "snooze" }
    ],
    calendars: [
      {
        subresources: true,
        name: :calendar_items,
        subitems: [
          {
            subresources: true,
            name: :calendar_item_reminders
          }
        ]
      }
    ],
    connections: [
      { instance: false, link: "allconnections" },
      { instance: true, link: "accept" }
    ],
    contacts: [
      { instance: true, link: "groups" },
      {
        subresources: true,
        name: :conversations
      }
    ],
    credit_cards: [
      { instance: false, link: "total_credit" },
      { instance: false, link: "listcashback" }
    ],
    due_items: [
      { instance: true, link: "complete" },
      { instance: true, link: "snooze" }
    ],
    emails: [
      { instance: true, link: "personalize" }
    ],
    events: [
      { instance: true, link: "share" },
      { instance: true, link: "shared" },
      { instance: true, link: "rsvp" }
    ],
    feeds: [
      { instance: false, link: "load_all" },
      { instance: true, link: "load" },
      { instance: true, link: "mark_all_read" },
      {
        subresources: true,
        name: :feed_items,
        subitems: [
          { instance: true, link: "mark_read" }
        ]
      }
    ],
    flights: [
      { instance: true, link: "send_info" }
    ],
    groups: [
      { instance: true, link: "email_list" },
      { instance: true, link: "missing_list" }
    ],
    identity_file_folders: [
      {
        resourcesinfo: true,
        as: "file_folders",
        path: "file_folders",
        controller: "file_folders"
      }
    ],
    identity_files: [
      {
        resourcesinfo: true,
        as: "files",
        path: "files",
        controller: "files"
      },
      { instance: true, link: "rotate" },
      { instance: true, link: "move" },
      { instance: true, link: "view" },
      { instance: true, link: "thumbnail" },
      { instance: true, link: "download" }
    ],
    media_dumps: [
      {
        subresources: true,
        name: :media_dump_files,
        subitems: [
          { instance: false, link: "destroy_all" }
        ]
      }
    ],
    money_balances: [
      { instance: true, link: "add" },
      { instance: true, link: "list" },
      {
        subresources: true,
        name: :money_balance_item_templates
      },
      {
        subresources: true,
        name: :money_balance_items
      }
    ],
    password_shares: [
      { instance: true, link: "transfer" }
    ],
    passwords: [
      { instance: true, link: "share_password" },
      { instance: false, link: "import" },
    ],
    periodic_payments: [
      { instance: false, link: "monthly_total" }
    ],
    permission_shares: [
      { instance: true, link: "personalize" }
    ],
    permissions: [
      { instance: false, link: "share" },
      { instance: false, link: "share_token" }
    ],
    playlists: [
      { instance: true, link: "share" },
      { instance: true, link: "shared" }
    ],
    podcasts: [
      { instance: false, link: "load_all" },
      { instance: true, link: "load" },
      { instance: true, link: "mark_all_read" }
    ],
    projects: [
      { instance: true, link: "delete_by_index" },
      {
        subresources: true,
        name: :project_issues,
        subitems: [
          { instance: true, link: "movetop" }
        ]
      }
    ],
    restaurants: [
      { instance: false, link: "random" }
    ],
    timings: [
      {
        subresources: true,
        name: :timing_events
      }
    ],
    trips: [
      { instance: true, link: "share" },
      { instance: true, link: "shared" },
      { instance: true, link: "complete" },
      {
        subresources: true,
        name: :trip_pictures,
        subitems: [
          { instance: false, link: "destroy_all" }
        ]
      },
      {
        subresources: true,
        name: :trip_stories
      }
    ],
    website_lists: [
      { instance: true, link: "roll" }
    ]
  }

  overriden = []

  Myp.process_models do |klass|
    klass_table_name = klass.table_name
    #Rails.logger.debug{"routes top level name: #{klass_table_name}"}
    if overriden.index(klass_table_name.to_sym).nil?
      process_resources(klass_table_name, additions[klass_table_name.to_sym])
    end
  end
  
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

  process_resources(:users, additions[:users])
  
  mount Ckeditor::Engine => '/ckeditor'
  
  puts{"Finished loading routes"}
  
end
