Rails.application.routes.draw do
  
  Rails.logger.debug{"routes.rb Started loading routes"}
  
  use_doorkeeper
  use_doorkeeper_openid_connect

  root "welcome#index"

  RouteHelpers.routes_index(self, %w(
    admin
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
  
  RouteHelpers.routes_get(self, %w(
    welcome/index
    graph/source_values
    graph/display
    map/display
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
    admin/create_test_error_job
    admin/gc
    admin/reinitialize
    search/show
    info/credits
    info/diagnostics
    info/sleep_time
    info/raise_server_exception
    info/raise_server_warning
    info/faq
    info/tips
    info/about
    info/privacy
    info/terms
    info/mission_statement
    info/clear_cookies
    internal_content/static_homepage
    test/test1
    test/test2
    test/throw
    test/hello_world
    test_api/hello_world
    users/allusers
    help/features
    help/highlights
    help/category
    api/enter_invite_code
  ))

  RouteHelpers.routes_post(self, %w(
    file_folders/new
    api/debug
    api/renderpartial
    api/quickfeedback
    api/newfile
    api/twilio_sms
    api/login_or_register
    api/refresh_token
    api/add_identity
    api/change_identity
    api/delete_identity
    api/update_password
    api/update_email
    api/forgot_password
    api/update_settings
    api/set_child_file
  ))

  RouteHelpers.routes_get_post(self, %w(
    tools/gps
    tools/urlencode
    tools/urldecode
    random/activity
    info/contact
    info/invite
    info/upload
    admin/send_email
    admin/send_text_message
    admin/send_direct_email
    admin/send_direct_text_message
    admin/execute_command
  ))

  match 'c/:id', :to => 'calendar_item_reminder_pendings#short', via: [:get], as: "calendar_item_reminder_short"

  match 'm/:id/:token', :to => 'text_messages#short', via: [:get], as: "text_message_short"

  match 'passwords/import/odf', :to => 'passwords#importodf', via: [:get, :post]
  match 'passwords/import/odf/:id/step1', :to => 'passwords#importodf1', via: [:get, :post], :as => "passwords_import_odf1"
  match 'passwords/import/odf/:id/step2', :to => 'passwords#importodf2', via: [:get, :post], :as => "passwords_import_odf2"
  match 'api/newfile2', :to => 'api#newfile', via: [:get, :post], :as => "api_newfile2"
  match 'api/set_child_file2', :to => 'api#set_child_file', via: [:get, :post], :as => "api_set_child_file2"

  match 'passwords/import/odf/:id/step3', :to => 'passwords#importodf3', via: [:get, :post], :as => "passwords_import_odf3"

  get 'info/diagnostics/checkboxes', :to => 'info#checkboxes'
  get 'info/diagnostics/serverinfo', :to => 'info#serverinfo'
  get 'info/diagnostics/clientinfo', :to => 'info#clientinfo'
  match 'info/diagnostics/decrypt', :to => 'info#decrypt', via: [:get, :post]
  match 'info/diagnostics/dovecot_password', :to => 'info#dovecot_password', via: [:get, :post]
  get 'info/diagnostics/hello_world', :to => 'info#hello_world'
  get 'info/diagnostics/jqm', :to => 'info#jqm'
  get 'badges/42', :to => 'badges#n42'

  match 'files/:id/view/*imagename', :to => 'files#view', via: [:get], as: "file_view_name"
  match 'files/:id/thumbnail/*imagename', :to => 'files#thumbnail', via: [:get], as: "file_thumbnail_name"
  match 'files/:id/thumbnail2/*imagename', :to => 'files#thumbnail2', via: [:get], as: "file_thumbnail2_name"
  match 'files/:id/download/*imagename', :to => 'files#download', via: [:get], as: "file_download_name"

  match 'favicon.ico', :to => 'api#favicon_ico', via: [:get]
  match 'api/favicon.ico', :to => 'api#favicon_ico', via: [:get]
  match 'api/favicon.png', :to => 'api#favicon_png', via: [:get]
  match 'api/header_icon.png', :to => 'api#header_icon_png', via: [:get]

  match 'blogs/:id/uploads/*uploadname', :to => 'blogs#upload', via: [:get], as: "blog_upload"
  match 'blogs/:id/upload_thumbnails/*uploadname', :to => 'blogs#upload_thumbnail', via: [:get], as: "blog_upload_thumbnail"
  match 'blogs/:id/page/*pagename', :to => 'blogs#page', via: [:get], as: "blog_page"

  match 'person_or_group/:id', :to => 'agents#show', via: [:get], as: "agent_alias"

  additions = {
    bets: [
      { instance: true, link: "update_status" },
      { instance: false, link: "history" },
    ],
    books: [
      { instance: true, link: "discard" },
    ],
    blogs: [
      { instance: true, link: "display" },
      { instance: true, link: "rss" },
      {
        subresources: true,
        name: :blog_posts,
        subitems: [
          {
            subresources: true,
            name: :blog_post_comments,
          }
        ]
      },
    ],
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
            name: :calendar_item_reminders,
            subitems: [
              {
                subresources: true,
                name: :calendar_item_reminder_pendings
              }
            ]
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
      { instance: true, link: "combine" },
      {
        subresources: true,
        name: :conversations
      }
    ],
    credit_cards: [
      { instance: false, link: "total_credit" },
      { instance: false, link: "listcashback" },
    ],
    diets: [
      { instance: true, link: "evaluate" },
      { instance: true, link: "consume" },
      {
        subresources: true,
        name: :diet_foods
      },
    ],
    dna_analyses: [
      { instance: true, link: "rerun" }
    ],
    drink_lists: [
      {
        subresources: true,
        name: :drink_list_drinks
      },
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
      { instance: true, link: "rsvp" },
      {
        subresources: true,
        name: :event_stories
      }
    ],
    exports: [
      { instance: true, link: "export" }
    ],
    feeds: [
      { instance: false, link: "all_items" },
      { instance: false, link: "load_all" },
      { instance: false, link: "random" },
      { instance: true, link: "load" },
      { instance: true, link: "mark_page_read" },
      { instance: true, link: "mark_all_read" },
      {
        subresources: true,
        name: :feed_items,
        subitems: [
          { instance: true, link: "mark_read" },
          { instance: true, link: "read_and_redirect" },
        ]
      }
    ],
    financial_assets: [
      { instance: false, link: "totals" },
    ],
    food_lists: [
      {
        subresources: true,
        name: :food_list_foods
      },
    ],
    flights: [
      { instance: true, link: "send_info" },
      { instance: true, link: "timings" }
    ],
    groups: [
      { instance: true, link: "email_list" },
      { instance: true, link: "missing_list" },
      { instance: true, link: "empty" },
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
      { instance: true, link: "thumbnail2" },
      { instance: true, link: "download" }
    ],
    imports: [
      { instance: true, link: "import" }
    ],
    jobs: [
      { instance: false, link: "resume" },
      {
        subresources: true,
        name: :job_accomplishments
      },
      {
        subresources: true,
        name: :job_salaries
      },
      {
        subresources: true,
        name: :job_reviews
      },
      {
        subresources: true,
        name: :job_myreferences
      },
      {
        subresources: true,
        name: :job_awards
      },
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
    paid_taxes: [
      { instance: false, link: "totals" },
    ],
    password_shares: [
      { instance: true, link: "transfer" }
    ],
    passwords: [
      { instance: true, link: "password_share" },
      { instance: false, link: "import" },
      { instance: false, link: "list" },
    ],
    periodic_payments: [
      { instance: false, link: "monthly_total" }
    ],
    perishable_foods: [
      { instance: true, link: "consume_one" },
      { instance: true, link: "consume_all" },
      { instance: true, link: "move" },
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
    quizzes: [
      { instance: true, link: "start" },
      { instance: true, link: "autogenerate" },
      {
        subresources: true,
        name: :quiz_items,
        subitems: [
          { instance: true, link: "quiz_show" },
          { instance: true, link: "copy" },
          { instance: true, link: "cut" },
          { instance: true, link: "ignore" },
        ]
      },
      {
        subresources: true,
        name: :quiz_instances,
        subitems: [
          { instance: true, link: "go" },
          { instance: true, link: "restart" },
          { instance: true, link: "reset_end" },
        ]
      },
    ],
    recreational_vehicles: [
      {
        subresources: true,
        name: :recreational_vehicle_measurements
      },
      {
        subresources: true,
        name: :recreational_vehicle_services
      }
    ],
    regimens: [
      { instance: true, link: "reset" },
      { instance: true, link: "complete_item" }
    ],
    reminders: [
      { instance: true, link: "refresh" },
    ],
    reputation_reports: [
      { instance: true, link: "contact_reporter" },
      { instance: true, link: "contact_accused" },
      { instance: true, link: "propose_price" },
      { instance: true, link: "request_status" },
      { instance: true, link: "update_status" },
      { instance: true, link: "initial_decision" },
      { instance: true, link: "review" },
      { instance: true, link: "unpublish" },
      { instance: true, link: "ensure_agent_contact" },
      { instance: true, link: "mediation" },
      { instance: true, link: "accusations" },
      {
        subresources: true,
        name: :reputation_report_messages
      },
    ],
    restaurants: [
      { instance: false, link: "random" }
    ],
    retirement_plans: [
      {
        subresources: true,
        name: :retirement_plan_amounts
      }
    ],
    site_invoices: [
      { instance: true, link: "pay" },
      { instance: true, link: "pay_other" },
      { instance: true, link: "paypal_complete" },
      { instance: true, link: "mark_paid" },
    ],
    test_objects: [
      { instance: false, link: "static_page" },
      { instance: true, link: "instance_page" },
      {
        subresources: true,
        name: :test_object_instances
      },
    ],
    text_messages: [
      { instance: true, link: "shared" },
      { instance: false, link: "unsubscribe" },
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
      { instance: true, link: "leaving" },
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
    vehicles: [
      {
        subresources: true,
        name: :vehicle_services
      }
    ],
    wallets: [
      {
        subresources: true,
        name: :wallet_transactions
      },
    ],
    website_domains: [
      { instance: true, link: "update_myplets" },
    ],
    website_lists: [
      { instance: true, link: "roll" }
    ],
    website_scrapers: [
      { instance: true, link: "scrape" },
      { instance: true, link: "test" },
    ],
  }

  overriden = [:users, :event_rsvps]

  Rails.logger.debug{"routes.rb Started processing all models"}

  if Rails.env.development?
    models_count = Myp.models_count.to_f
  end
  
  count = 0
  processed = {}
  
  Myp.process_model_names do |model_name|
    table_name = model_name.pluralize
    if overriden.index(table_name.to_sym).nil?
      if Rails.env.development?
        count += 1
        p = (count.to_f / models_count) * 100.0
        if p > 1 && p.to_i % 10.0 == 0 && processed[p.to_i].nil?
          processed[p.to_i] = true
          Rails.logger.debug{"routes.rb Processing models: #{p.to_i}%"}
        end
      end
      RouteHelpers.process_resources(self, table_name, additions[table_name.to_sym])
    end
  end
  
  Rails.logger.debug{"routes.rb Ended processing all models"}

  # GET /resource/password/edit?reset_password_token=abcdef
  if Myp.is_web_server? || Rails.env.test?
    devise_scope :user do
      match 'users/reenter', :to => 'users/sessions#reenter', via: [:get, :post]
      post 'users/sign_up', :to => 'users/registrations#new'
      get 'users/delete', :to => 'users/registrations#delete'
      match 'users/password/change', :to => 'users/registrations#changepassword', via: [:get, :put]
      match 'users/password/edit', :to => 'users/passwords#edit', via: [:get]
      match 'users/password/edit', :to => 'users/passwords#update', via: [:put]
      match 'users/changeemail', :to => 'users/registrations#changeemail', via: [:get, :put]
      match 'users/notifications', :to => 'users/registrations#notifications', via: [:get, :post]
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

  RouteHelpers.process_resources(self, :users, additions[:users])
  
  mount Ckeditor::Engine => '/ckeditor'
  
  Rails.logger.debug{"routes.rb Finished loading routes"}
end
