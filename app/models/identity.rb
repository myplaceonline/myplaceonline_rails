class Identity < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :middle_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :last_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :nickname, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :birthday, type: ApplicationRecord::PROPERTY_TYPE_DATE },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :likes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :gift_ideas, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :ktn, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :sex_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :new_years_resolution, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :display_note, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :identity_type, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :identity_phones, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :identity_emails, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :identity_locations, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :identity_relationships, type: ApplicationRecord::PROPERTY_TYPE_CHILDREN },
      { name: :identity_pictures, type: ApplicationRecord::PROPERTY_TYPE_FILES },
      { name: :company, type: ApplicationRecord::PROPERTY_TYPE_CHILD },
      { name: :blood_type, type: ApplicationRecord::PROPERTY_TYPE_SELECT },
      { name: :_updatetype, type: ApplicationRecord::PROPERTY_TYPE_HIDDEN },
    ]
  end
      
  DEFAULT_BIRTHDAY_THRESHOLD_SECONDS = 60.days.seconds
  
  CALENDAR_ITEM_CONTEXT_BIRTHDAY = "birthday"
  
  IDENTITY_TYPE_CONTACT = 0
  IDENTITY_TYPE_COMPANY = 1
  IDENTITY_TYPE_AGENT = 2
  
  BLOOD_TYPE_AMINUS = 0
  BLOOD_TYPE_APLUS = 1
  BLOOD_TYPE_BMINUS = 2
  BLOOD_TYPE_BPLUS = 3
  BLOOD_TYPE_ABMINUS = 4
  BLOOD_TYPE_ABPLUS = 5
  BLOOD_TYPE_OMINUS = 6
  BLOOD_TYPE_OPLUS = 7

  BLOOD_TYPES = [
    ["myplaceonline.contacts.blood_types.aminus", BLOOD_TYPE_AMINUS],
    ["myplaceonline.contacts.blood_types.aplus", BLOOD_TYPE_APLUS],
    ["myplaceonline.contacts.blood_types.bminus", BLOOD_TYPE_BMINUS],
    ["myplaceonline.contacts.blood_types.bplus", BLOOD_TYPE_BPLUS],
    ["myplaceonline.contacts.blood_types.abminus", BLOOD_TYPE_ABMINUS],
    ["myplaceonline.contacts.blood_types.abplus", BLOOD_TYPE_ABPLUS],
    ["myplaceonline.contacts.blood_types.ominus", BLOOD_TYPE_OMINUS],
    ["myplaceonline.contacts.blood_types.oplus", BLOOD_TYPE_OPLUS],
  ]
  
  MESSAGE_PREFERENCE_NONE = 0
  MESSAGE_PREFERENCE_EMAIL = 1
  MESSAGE_PREFERENCE_SMS = 2
  MESSAGE_PREFERENCE_APP = 4
  
  MESSAGE_PREFERENCES = [
    ["myplaceonline.contacts.message_preferences.message_preference_none", MESSAGE_PREFERENCE_NONE],
    ["myplaceonline.contacts.message_preferences.message_preference_email", MESSAGE_PREFERENCE_EMAIL],
    ["myplaceonline.contacts.message_preferences.message_preference_sms", MESSAGE_PREFERENCE_SMS],
    #["myplaceonline.contacts.message_preferences.message_preference_app", MESSAGE_PREFERENCE_APP],
    ["myplaceonline.contacts.message_preferences.message_preference_email_and_sms", MESSAGE_PREFERENCE_EMAIL | MESSAGE_PREFERENCE_SMS],
  ]

  has_one :contact, class_name: "Contact", foreign_key: :contact_identity_id
  
  def self.email_to_name(email)
    email[0..email.index("@")-1]
  end
  
  def name_from_email
    user.nil? ? nil : Identity.email_to_name(user.email)
  end
  
  validates :name, presence: true

  def ensure_contact!
    result = Contact.find_by(
      identity_id: self.id,
      contact_identity_id: self.id
    )
    if result.nil?
      ApplicationRecord.transaction do
        result = Contact.new
        if self.name.blank?
          self.name = name_from_email
          self.save!
        end
        result.identity = self
        result.contact_identity = self
        result.save!
      end
    end
    
    if !user.nil? && self.identity_emails.count == 0
      IdentityEmail.create!(
        parent_identity_id: self.id,
        identity_id: self.id,
        email: user.email,
      )
    end
    
    result
  end
  
  def default_name?
    name == name_from_email
  end
  
  belongs_to :user
  
  # The order of these matters in the case of deletion. For example, let's say
  # some model1 has a child_files field with a model2 that has an IdentityFile
  # field, and if :identity_files occurs before model1 in the list below,
  # then Rails will try to delete :identity_files before model1, and this will
  # cause foreign reference violations because model2 still has rferences to
  # those files.

  @@destroy_callbacks = []
  
  def self.register_destroy_callback(destroy_callback)
    Rails.logger.debug{"Identity.register_destroy_callback #{destroy_callback}"}
    @@destroy_callbacks.push(destroy_callback)
  end
  
  before_destroy :on_before_destroy
  
  def on_before_destroy
    Rails.logger.debug{"Identity.on_before_destroy callbacks: #{@@destroy_callbacks.size}"}
    @@destroy_callbacks.each do |destroy_callback|
      destroy_callback.call(self)
    end
  end
  
  has_many :point_displays, :dependent => :destroy
  has_many :genotype_calls, :dependent => :destroy
  has_many :dna_analyses, :dependent => :destroy
  has_many :passwords, :dependent => :destroy
  has_many :identity_files, :dependent => :destroy
  has_many :identity_file_folders, :dependent => :destroy
  has_many :category_points_amounts, :dependent => :destroy
  has_many :movies, :dependent => :destroy
  has_many :wisdoms, :dependent => :destroy
  has_many :to_dos, :dependent => :destroy
  has_many :contacts, :dependent => :destroy
  has_many :accomplishments, :dependent => :destroy
  has_many :feeds, :dependent => :destroy
  has_many :locations, :dependent => :destroy
  has_many :activities, :dependent => :destroy
  has_many :apartments, :dependent => :destroy
  has_many :jokes, :dependent => :destroy
  has_many :companies, :dependent => :destroy
  has_many :promises, :dependent => :destroy
  has_many :memberships, :dependent => :destroy
  has_many :credit_scores, :dependent => :destroy
  has_many :websites, :dependent => :destroy
  has_many :credit_cards, :dependent => :destroy
  has_many :bank_accounts, :dependent => :destroy
  has_many :ideas, :dependent => :destroy
  has_many :lists, :dependent => :destroy
  has_many :calculation_forms, :dependent => :destroy
  has_many :calculations, :dependent => :destroy
  has_many :vehicles, :dependent => :destroy
  has_many :questions, :dependent => :destroy
  has_many :weights, :dependent => :destroy
  has_many :blood_pressures, :dependent => :destroy
  has_many :heart_rates, :dependent => :destroy
  has_many :recipes, :dependent => :destroy
  has_many :sleep_measurements, :dependent => :destroy
  has_many :heights, :dependent => :destroy
  has_many :meals, :dependent => :destroy
  has_many :recreational_vehicles, :dependent => :destroy
  has_many :acne_measurements, :dependent => :destroy
  has_many :exercises, :dependent => :destroy
  has_many :sun_exposures, :dependent => :destroy
  has_many :medicine_usages, :dependent => :destroy
  has_many :pains, :dependent => :destroy
  has_many :songs, :dependent => :destroy
  has_many :blood_tests, :dependent => :destroy
  has_many :checklists, :dependent => :destroy
  has_many :medical_conditions, :dependent => :destroy
  has_many :life_goals, :dependent => :destroy
  has_many :temperatures, :dependent => :destroy
  has_many :headaches, :dependent => :destroy
  has_many :skin_treatments, :dependent => :destroy
  has_many :periodic_payments, :dependent => :destroy
  has_many :jobs, :dependent => :destroy
  has_many :trips, :dependent => :destroy
  has_many :passports, :dependent => :destroy
  has_many :promotions, :dependent => :destroy
  has_many :reward_programs, :dependent => :destroy
  has_many :computers, :dependent => :destroy
  has_many :life_insurances, :dependent => :destroy
  has_many :diary_entries, :dependent => :destroy
  has_many :restaurants, :dependent => :destroy
  has_many :camp_locations, :dependent => :destroy
  has_many :guns, :dependent => :destroy
  has_many :desired_products, :dependent => :destroy
  has_many :books, :dependent => :destroy
  has_many :favorite_products, :dependent => :destroy
  has_many :therapists, :dependent => :destroy
  has_many :health_insurances, :dependent => :destroy
  has_many :doctors, :dependent => :destroy
  has_many :dental_insurances, :dependent => :destroy
  has_many :hobbies, :dependent => :destroy
  has_many :poems, :dependent => :destroy
  has_many :musical_groups, :dependent => :destroy
  has_many :dentist_visits, :dependent => :destroy
  has_many :doctor_visits, :dependent => :destroy
  has_many :statuses, :dependent => :destroy
  has_many :notepads, :dependent => :destroy
  has_many :myplaceonline_searches, :dependent => :destroy
  has_many :myplaceonline_quick_category_displays, :dependent => :destroy
  has_many :calendars, :dependent => :destroy
  has_many :concerts, :dependent => :destroy
  has_many :shopping_lists, :dependent => :destroy
  has_many :groups, :dependent => :destroy
  has_many :phones, :dependent => :destroy
  has_many :movie_theaters, :dependent => :destroy
  has_many :gas_stations, :dependent => :destroy
  has_many :events, :dependent => :destroy
  has_many :stocks, :dependent => :destroy
  has_many :museums, :dependent => :destroy
  has_many :date_locations, :dependent => :destroy
  has_many :playlists, :dependent => :destroy
  has_many :bars, :dependent => :destroy
  has_many :treks, :dependent => :destroy
  has_many :money_balances, :dependent => :destroy
  has_many :permissions, :dependent => :destroy
  has_many :receipts, :dependent => :destroy
  has_many :stories, :dependent => :destroy
  has_many :dessert_locations, :dependent => :destroy
  has_many :desired_locations, :dependent => :destroy
  has_many :book_stores, :dependent => :destroy
  has_many :volunteering_activities, :dependent => :destroy
  has_many :happy_things, :dependent => :destroy
  has_many :annuities, :dependent => :destroy
  has_many :podcasts, :dependent => :destroy
  has_many :hotels, :dependent => :destroy
  has_many :emails, :dependent => :destroy
  has_many :drafts, :dependent => :destroy
  has_many :awesome_lists, :dependent => :destroy
  has_many :ssh_keys, :dependent => :destroy
  has_many :cafes, :dependent => :destroy
  has_many :charities, :dependent => :destroy
  has_many :quests, :dependent => :destroy
  has_many :timings, :dependent => :destroy
  has_many :emergency_contacts, :dependent => :destroy
  has_many :tv_shows, :dependent => :destroy
  has_many :website_domains, :dependent => :destroy
  has_many :bets, :dependent => :destroy
  has_many :meadows, :dependent => :destroy
  has_many :web_comics, :dependent => :destroy
  has_many :projects, :dependent => :destroy
  has_many :flights, :dependent => :destroy
  has_many :text_messages, :dependent => :destroy
  has_many :business_cards, :dependent => :destroy
  has_many :problem_reports, :dependent => :destroy
  has_many :connections, :dependent => :destroy
  has_many :myreferences, :dependent => :destroy
  has_many :dreams, :dependent => :destroy
  has_many :messages, :dependent => :destroy
  has_many :media_dumps, :dependent => :destroy
  has_many :website_lists, :dependent => :destroy
  has_many :exercise_regimens, :dependent => :destroy
  has_many :favorite_locations, :dependent => :destroy
  has_many :life_highlights, :dependent => :destroy
  has_many :educations, :dependent => :destroy
  has_many :email_accounts, :dependent => :destroy
  has_many :documents, :dependent => :destroy
  has_many :retirement_plans, :dependent => :destroy
  has_many :perishable_foods, :dependent => :destroy
  has_many :items, :dependent => :destroy
  has_many :vaccines, :dependent => :destroy
  has_many :test_objects, :dependent => :destroy
  has_many :tax_documents, :dependent => :destroy
  has_many :quotes, :dependent => :destroy
  has_many :prescriptions, :dependent => :destroy
  has_many :donations, :dependent => :destroy
  has_many :checks, :dependent => :destroy
  has_many :test_scores, :dependent => :destroy
  has_many :bills, :dependent => :destroy
  has_many :patents, :dependent => :destroy
  has_many :dating_profiles, :dependent => :destroy
  has_many :memories, :dependent => :destroy
  has_many :software_licenses, :dependent => :destroy
  has_many :music_albums, :dependent => :destroy
  has_many :surgeries, :dependent => :destroy
  has_many :injuries, :dependent => :destroy
  has_many :driver_licenses, :dependent => :destroy
  has_many :hospital_visits, :dependent => :destroy
  has_many :paid_taxes, :dependent => :destroy
  has_many :psychological_evaluations, :dependent => :destroy
  has_many :insurance_cards, :dependent => :destroy
  has_many :sicknesses, :dependent => :destroy
  has_many :picnic_locations, :dependent => :destroy
  has_many :user_capabilities, :dependent => :destroy
  has_many :website_scrapers, :dependent => :destroy
  has_many :regimens, :dependent => :destroy
  has_many :dietary_requirements_collections, :dependent => :destroy
  has_many :dietary_requirements, :dependent => :destroy
  has_many :diets, :dependent => :destroy
  has_many :consumed_foods, :dependent => :destroy
  has_many :beaches, :dependent => :destroy
  has_many :imports, :dependent => :destroy
  has_many :blogs, :dependent => :destroy
  has_many :translations, :dependent => :destroy
  has_many :boycotts, :dependent => :destroy
  has_many :reminders, :dependent => :destroy
  has_many :reputation_reports, :dependent => :destroy
  has_many :agents, :dependent => :destroy
  has_many :site_invoices, :dependent => :destroy
  has_many :computer_environments, :dependent => :destroy
  has_many :food_lists, :dependent => :destroy
  has_many :security_tokens, :dependent => :destroy
  has_many :exports, :dependent => :destroy
  has_many :wallets, :dependent => :destroy
  has_many :financial_assets, :dependent => :destroy
  has_many :boondockings, :dependent => :destroy
  has_many :allergies, :dependent => :destroy
  has_many :saved_games, :dependent => :destroy
  has_many :research_papers, :dependent => :destroy
  has_many :presents, :dependent => :destroy
  has_many :quizzes, :dependent => :destroy
  has_many :drink_lists, :dependent => :destroy
  has_many :credit_reports, :dependent => :destroy
  has_many :arts, :dependent => :destroy
  has_many :parking_locations, :dependent => :destroy
  has_many :videos, :dependent => :destroy
  has_many :notifications, :dependent => :destroy
  has_many :notification_preferences, :dependent => :destroy
  has_many :hospitals, :dependent => :destroy
  has_many :crontabs, :dependent => :destroy
  has_many :vehicle_washes, :dependent => :destroy
  has_many :haircuts, :dependent => :destroy
  has_many :mechanics, :dependent => :destroy
  has_many :wireless_networks, :dependent => :destroy
  has_many :mrobbles, :dependent => :destroy
  has_many :parks, :dependent => :destroy
  has_many :basketball_courts, :dependent => :destroy
  has_many :tennis_courts, :dependent => :destroy
  has_many :soccer_fields, :dependent => :destroy
  has_many :health_changes, :dependent => :destroy
  has_many :airline_programs, :dependent => :destroy
  has_many :locks, :dependent => :destroy
  has_many :memes, :dependent => :destroy
  has_many :gift_stores, :dependent => :destroy
  has_many :barbecues, :dependent => :destroy
  has_many :steakhouses, :dependent => :destroy
  has_many :settings, :dependent => :destroy
  has_many :email_tokens, :dependent => :destroy
  
  child_properties(name: :myplets, sort: "y_coordinate")

  child_properties(name: :identity_phones, foreign_key: "parent_identity_id")
  
  child_properties(name: :identity_emails, foreign_key: "parent_identity_id")
  
  child_properties(name: :identity_clothes, foreign_key: "parent_identity_id", sort: "when_date DESC")
  
  def emails
    identity_emails.to_a.delete_if{|ie| ie.secondary }.map{|ie| ie.email }
  end
  
  def one_email
    result = nil
    e = self.emails
    if e.length > 0
      result = e[0]
    end
    result
  end
  
  def has_email?
    self.emails.length > 0
  end
  
  child_properties(name: :identity_locations, foreign_key: "parent_identity_id")
  
  def primary_location
    result = nil
    if identity_locations.length == 1
      result = identity_locations.first
    else
      non_secondaries = identity_locations.to_a.dup.delete_if{|x| x.secondary}
      if non_secondaries.length == 1
        result = non_secondaries.first
      end
    end
    if !result.nil?
      result = result.location
    end
    result
  end
  
  child_properties(name: :identity_drivers_licenses, foreign_key: "parent_identity_id")
  
  child_properties(name: :identity_relationships, foreign_key: "parent_identity_id")
  
  child_properties(name: :identity_pictures, foreign_key: "parent_identity_id")
  
  child_property(name: :website_domain, autosave: false, validate: false)
  
  child_property(name: :company)
  
  def is_type_contact?
    self.identity_type.nil? || self.identity_type == Identity::IDENTITY_TYPE_CONTACT
  end
  
  validate do
    if !name.blank? && self.last_name.blank? && self.is_type_contact?
      splits = name.split(" ")
      if splits.length > 1
        self.name = splits[0]
        self.last_name = splits[splits.length-1]
        if splits.length > 2
          splits.delete_at(0)
          splits.delete_at(splits.length - 1)
          self.middle_name = splits.join(" ")
        end
      end
    end
  end

  def as_json(options={})
    super.as_json(options).merge({
      :category_points_amounts => category_points_amounts.to_a.map{|x| x.as_json},
      :passwords => passwords.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :movies => movies.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :wisdoms => wisdoms.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :to_dos => to_dos.to_a.sort{ |a,b| a.short_description.downcase <=> b.short_description.downcase }.map{|x| x.as_json},
      :contacts => contacts.to_a.delete_if{|x| x.contact_identity_id == id }.map{|x| x.as_json},
      :accomplishments => accomplishments.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :feeds => feeds.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :locations => locations.to_a.sort{ |a,b| a.display.downcase <=> b.display.downcase }.map{|x| x.as_json},
      :activities => activities.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :apartments => apartments.to_a.map{|x| x.as_json},
      :jokes => jokes.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :companies => companies.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :promises => promises.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :memberships => memberships.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :credit_scores => credit_scores.to_a.map{|x| x.as_json},
      :websites => websites.to_a.sort{ |a,b| a.title.downcase <=> b.title.downcase }.map{|x| x.as_json},
      :credit_cards => credit_cards.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :bank_accounts => bank_accounts.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :ideas => ideas.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :lists => lists.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :calculation_forms => calculation_forms.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :calculations => calculations.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :vehicles => vehicles.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :questions => questions.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :weights => weights.to_a.map{|x| x.as_json},
      :blood_pressures => blood_pressures.to_a.map{|x| x.as_json},
      :heart_rates => heart_rates.to_a.map{|x| x.as_json},
      :recipes => recipes.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :sleep_measurements => sleep_measurements.to_a.map{|x| x.as_json},
      :heights => heights.to_a.map{|x| x.as_json},
      :meals => meals.to_a.map{|x| x.as_json},
      :recreational_vehicles => recreational_vehicles.to_a.sort{ |a,b| a.rv_name.downcase <=> b.rv_name.downcase }.map{|x| x.as_json},
      :acne_measurements => acne_measurements.to_a.map{|x| x.as_json},
      :exercises => exercises.to_a.map{|x| x.as_json},
      :sun_exposures => sun_exposures.to_a.map{|x| x.as_json},
      :medicine_usages => medicine_usages.to_a.map{|x| x.as_json},
      :pains => pains.to_a.map{|x| x.as_json},
      :songs => songs.to_a.sort{ |a,b| a.song_name.downcase <=> b.song_name.downcase }.map{|x| x.as_json},
      :blood_tests => blood_tests.to_a.map{|x| x.as_json},
      :checklists => checklists.to_a.sort{ |a,b| a.checklist_name.downcase <=> b.checklist_name.downcase }.map{|x| x.as_json},
      :medical_conditions => medical_conditions.to_a.sort{ |a,b| a.medical_condition_name.downcase <=> b.medical_condition_name.downcase }.map{|x| x.as_json},
      :life_goals => life_goals.to_a.sort{ |a,b| a.life_goal_name.downcase <=> b.life_goal_name.downcase }.map{|x| x.as_json},
      :temperatures => temperatures.to_a.map{|x| x.as_json},
      :headaches => headaches.to_a.map{|x| x.as_json},
      :skin_treatments => skin_treatments.to_a.map{|x| x.as_json},
      :periodic_payments => periodic_payments.to_a.sort{ |a,b| a.periodic_payment_name.downcase <=> b.periodic_payment_name.downcase }.map{|x| x.as_json},
      :jobs => jobs.to_a.sort{ |a,b| a.job_title.downcase <=> b.job_title.downcase }.map{|x| x.as_json},
      :trips => trips.to_a.map{|x| x.as_json},
      :passports => passports.to_a.map{|x| x.as_json},
      :promotions => promotions.to_a.sort{ |a,b| a.promotion_name.downcase <=> b.promotion_name.downcase }.map{|x| x.as_json},
      :reward_programs => reward_programs.to_a.sort{ |a,b| a.reward_program_name.downcase <=> b.reward_program_name.downcase }.map{|x| x.as_json},
      :computers => computers.to_a.sort{ |a,b| a.computer_model.downcase <=> b.computer_model.downcase }.map{|x| x.as_json},
      :life_insurances => life_insurances.to_a.sort{ |a,b| a.insurance_name.downcase <=> b.insurance_name.downcase }.map{|x| x.as_json},
      :diary_entries => diary_entries.to_a.map{|x| x.as_json},
      :restaurants => restaurants.to_a.map{|x| x.as_json},
      :camp_locations => camp_locations.to_a.map{|x| x.as_json},
      :guns => guns.to_a.sort{ |a,b| a.gun_name.downcase <=> b.gun_name.downcase }.map{|x| x.as_json},
      :desired_products => desired_products.to_a.sort{ |a,b| a.product_name.downcase <=> b.product_name.downcase }.map{|x| x.as_json},
      :books => books.to_a.sort{ |a,b| a.book_name.downcase <=> b.book_name.downcase }.map{|x| x.as_json},
      :favorite_products => favorite_products.to_a.sort{ |a,b| a.product_name.downcase <=> b.product_name.downcase }.map{|x| x.as_json},
      :therapists => therapists.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :doctors => doctors.to_a.map{|x| x.as_json},
      :health_insurances => health_insurances.to_a.sort{ |a,b| a.insurance_name.downcase <=> b.insurance_name.downcase }.map{|x| x.as_json},
      :dental_insurances => dental_insurances.to_a.sort{ |a,b| a.insurance_name.downcase <=> b.insurance_name.downcase }.map{|x| x.as_json},
      :hobbies => hobbies.to_a.sort{ |a,b| a.hobby_name.downcase <=> b.hobby_name.downcase }.map{|x| x.as_json},
      :poems => poems.to_a.sort{ |a,b| a.poem_name.downcase <=> b.poem_name.downcase }.map{|x| x.as_json},
      :musical_groups => musical_groups.to_a.sort{ |a,b| a.musical_group_name.downcase <=> b.musical_group_name.downcase }.map{|x| x.as_json},
      :dentist_visits => dentist_visits.to_a.map{|x| x.as_json},
      :doctor_visits => doctor_visits.to_a.map{|x| x.as_json},
      :statuses => statuses.to_a.map{|x| x.as_json},
      :notepads => notepads.to_a.sort{ |a,b| a.title.downcase <=> b.title.downcase }.map{|x| x.as_json},
      :myplaceonline_searches => myplaceonline_searches.to_a.map{|x| x.as_json},
      :myplaceonline_quick_category_displays => myplaceonline_quick_category_displays.to_a.map{|x| x.as_json},
      :calendars => calendars.to_a.map{|x| x.as_json},
      :concerts => concerts.to_a.sort{ |a,b| a.concert_title.downcase <=> b.concert_title.downcase }.map{|x| x.as_json},
      :shopping_lists => shopping_lists.to_a.sort{ |a,b| a.shopping_list_name.downcase <=> b.shopping_list_name.downcase }.map{|x| x.as_json},
      :groups => groups.to_a.sort{ |a,b| a.group_name.downcase <=> b.group_name.downcase }.map{|x| x.as_json},
      :phones => phones.to_a.sort{ |a,b| a.phone_model_name.downcase <=> b.phone_model_name.downcase }.map{|x| x.as_json},
      :movie_theaters => movie_theaters.to_a.map{|x| x.as_json},
      :gas_stations => gas_stations.to_a.map{|x| x.as_json},
      :events => events.to_a.sort{ |a,b| a.event_name.downcase <=> b.event_name.downcase }.map{|x| x.as_json},
      :stocks => stocks.to_a.map{|x| x.as_json},
      :museums => museums.to_a.map{|x| x.as_json},
      :date_locations => date_locations.to_a.map{|x| x.as_json},
      :playlists => playlists.to_a.sort{ |a,b| a.playlist_name.downcase <=> b.playlist_name.downcase }.map{|x| x.as_json},
      :bars => bars.to_a.map{|x| x.as_json},
      :treks => treks.to_a.map{|x| x.as_json},
      :money_balances => money_balances.to_a.map{|x| x.as_json},
      :permissions => permissions.to_a.map{|x| x.as_json},
      :receipts => receipts.to_a.sort{ |a,b| a.receipt_name.downcase <=> b.receipt_name.downcase }.map{|x| x.as_json},
      :stories => stories.to_a.sort{ |a,b| a.story_name.downcase <=> b.story_name.downcase }.map{|x| x.as_json},
      :dessert_locations => dessert_locations.to_a.map{|x| x.as_json},
      :desired_locations => desired_locations.to_a.map{|x| x.as_json},
      :book_stores => book_stores.to_a.map{|x| x.as_json},
      :volunteering_activities => volunteering_activities.to_a.map{|x| x.as_json},
      :happy_things => happy_things.to_a.sort{ |a,b| a.happy_thing_name.downcase <=> b.happy_thing_name.downcase }.map{|x| x.as_json},
      :annuities => annuities.to_a.sort{ |a,b| a.annuity_name.downcase <=> b.annuity_name.downcase }.map{|x| x.as_json},
      :podcasts => podcasts.to_a.map{|x| x.as_json},
      :hotels => hotels.to_a.map{|x| x.as_json},
      :emails => emails.to_a.map{|x| x.as_json},
      :drafts => drafts.to_a.sort{ |a,b| a.draft_name.downcase <=> b.draft_name.downcase }.map{|x| x.as_json},
      :awesome_lists => awesome_lists.to_a.map{|x| x.as_json},
      :ssh_keys => ssh_keys.to_a.sort{ |a,b| a.ssh_key_name.downcase <=> b.ssh_key_name.downcase }.map{|x| x.as_json},
      :cafes => cafes.to_a.map{|x| x.as_json},
      :quests => quests.to_a.sort{ |a,b| a.quest_title.downcase <=> b.quest_title.downcase }.map{|x| x.as_json},
      :timings => timings.to_a.sort{ |a,b| a.timing_name.downcase <=> b.timing_name.downcase }.map{|x| x.as_json},
      :emergency_contacts => emergency_contacts.to_a.map{|x| x.as_json},
      :tv_shows => tv_shows.to_a.sort{ |a,b| a.tv_show_name.downcase <=> b.tv_show_name.downcase }.map{|x| x.as_json},
      :website_domains => website_domains.to_a.sort{ |a,b| a.domain_name.downcase <=> b.domain_name.downcase }.map{|x| x.as_json},
      :bets => bets.to_a.sort{ |a,b| a.bet_name.downcase <=> b.bet_name.downcase }.map{|x| x.as_json},
      :meadows => meadows.to_a.map{|x| x.as_json},
      :web_comics => web_comics.to_a.sort{ |a,b| a.web_comic_name.downcase <=> b.web_comic_name.downcase }.map{|x| x.as_json},
      :projects => projects.to_a.sort{ |a,b| a.project_name.downcase <=> b.project_name.downcase }.map{|x| x.as_json},
      :flights => flights.to_a.sort{ |a,b| a.flight_name.downcase <=> b.flight_name.downcase }.map{|x| x.as_json},
      :text_messages => text_messages.to_a.map{|x| x.as_json},
      :business_cards => business_cards.to_a.map{|x| x.as_json},
      :problem_reports => problem_reports.to_a.sort{ |a,b| a.report_name.downcase <=> b.report_name.downcase }.map{|x| x.as_json},
      :connections => connections.to_a.map{|x| x.as_json},
      :myreferences => myreferences.to_a.map{|x| x.as_json},
      :dreams => dreams.to_a.sort{ |a,b| a.dream_name.downcase <=> b.dream_name.downcase }.map{|x| x.as_json},
      :messages => messages.to_a.map{|x| x.as_json},
      :media_dumps => media_dumps.to_a.sort{ |a,b| a.media_dump_name.downcase <=> b.media_dump_name.downcase }.map{|x| x.as_json},
      :website_lists => website_lists.to_a.sort{ |a,b| a.website_list_name.downcase <=> b.website_list_name.downcase }.map{|x| x.as_json},
      :exercise_regimens => exercise_regimens.to_a.sort{ |a,b| a.exercise_regimen_name.downcase <=> b.exercise_regimen_name.downcase }.map{|x| x.as_json},
      :favorite_locations => favorite_locations.to_a.map{|x| x.as_json},
      :life_highlights => life_highlights.to_a.map{|x| x.as_json},
      :educations => educations.to_a.sort{ |a,b| a.education_name.downcase <=> b.education_name.downcase }.map{|x| x.as_json},
      :email_accounts => email_accounts.to_a.map{|x| x.as_json},
      :documents => documents.to_a.sort{ |a,b| a.document_name.downcase <=> b.document_name.downcase }.map{|x| x.as_json},
      :retirement_plans => retirement_plans.to_a.sort{ |a,b| a.retirement_plan_name.downcase <=> b.retirement_plan_name.downcase }.map{|x| x.as_json},
      :perishable_foods => perishable_foods.to_a.map{|x| x.as_json},
      :items => items.to_a.sort{ |a,b| a.item_name.downcase <=> b.item_name.downcase }.map{|x| x.as_json},
      :vaccines => vaccines.to_a.sort{ |a,b| a.vaccine_name.downcase <=> b.vaccine_name.downcase }.map{|x| x.as_json},
      :test_objects => test_objects.to_a.map{|x| x.as_json},
      :tax_documents => tax_documents.to_a.sort{ |a,b| a.tax_document_form_name.downcase <=> b.tax_document_form_name.downcase }.map{|x| x.as_json},
      :quotes => quotes.to_a.map{|x| x.as_json},
      :prescriptions => prescriptions.to_a.sort{ |a,b| a.prescription_name.downcase <=> b.prescription_name.downcase }.map{|x| x.as_json},
      :donations => donations.to_a.sort{ |a,b| a.donation_name.downcase <=> b.donation_name.downcase }.map{|x| x.as_json},
      :checks => checks.to_a.sort{ |a,b| a.description.downcase <=> b.description.downcase }.map{|x| x.as_json},
      :test_scores => test_scores.to_a.map{|x| x.as_json},
      :bills => bills.to_a.map{|x| x.as_json},
      :patents => patents.to_a.map{|x| x.as_json},
      :dating_profiles => dating_profiles.to_a.map{|x| x.as_json},
      :memories => memories.to_a.map{|x| x.as_json},
      :software_licenses => software_licenses.to_a.map{|x| x.as_json},
      :music_albums => music_albums.to_a.map{|x| x.as_json},
      :surgeries => surgeries.to_a.map{|x| x.as_json},
      :injuries => injuries.to_a.map{|x| x.as_json},
      :driver_licenses => driver_licenses.to_a.map{|x| x.as_json},
      :hospital_visits => hospital_visits.to_a.map{|x| x.as_json},
      :paid_taxes => paid_taxes.to_a.map{|x| x.as_json},
      :psychological_evaluations => psychological_evaluations.to_a.map{|x| x.as_json},
      :insurance_cards => insurance_cards.to_a.map{|x| x.as_json},
      :sicknesses => sicknesses.to_a.map{|x| x.as_json},
      :picnic_locations => picnic_locations.to_a.map{|x| x.as_json},
      :user_capabilities => user_capabilities.to_a.map{|x| x.as_json},
      :website_scrapers => website_scrapers.to_a.map{|x| x.as_json},
      :regimens => regimens.to_a.map{|x| x.as_json},
      :dietary_requirements_collections => dietary_requirements_collections.to_a.map{|x| x.as_json},
      :dietary_requirements => dietary_requirements.to_a.map{|x| x.as_json},
      :diets => diets.to_a.map{|x| x.as_json},
      :consumed_foods => consumed_foods.to_a.map{|x| x.as_json},
      :beaches => beaches.to_a.map{|x| x.as_json},
      :imports => imports.to_a.map{|x| x.as_json},
      :blogs => blogs.to_a.map{|x| x.as_json},
      :translations => translations.to_a.map{|x| x.as_json},
      :boycotts => boycotts.to_a.map{|x| x.as_json},
      :reminders => reminders.to_a.map{|x| x.as_json},
      :dna_analyses => dna_analyses.to_a.map{|x| x.as_json},
      :reputation_reports => reputation_reports.to_a.map{|x| x.as_json},
      :agents => agents.to_a.map{|x| x.as_json},
      :site_invoices => site_invoices.to_a.map{|x| x.as_json},
      :computer_environments => computer_environments.to_a.map{|x| x.as_json},
      :food_lists => food_lists.to_a.map{|x| x.as_json},
      :security_tokens => security_tokens.to_a.map{|x| x.as_json},
      :exports => exports.to_a.map{|x| x.as_json},
      :boondockings => boondockings.to_a.map{|x| x.as_json},
      :saved_games => saved_games.to_a.map{|x| x.as_json},
      :research_papers => research_papers.to_a.map{|x| x.as_json},
      :presents => presents.to_a.map{|x| x.as_json},
      :quizzes => quizzes.to_a.map{|x| x.as_json},
      :drink_lists => drink_lists.to_a.map{|x| x.as_json},
      :credit_reports => credit_reports.to_a.map{|x| x.as_json},
      :arts => arts.to_a.map{|x| x.as_json},
      :parking_locations => parking_locations.to_a.map{|x| x.as_json},
      :notifications => notifications.to_a.map{|x| x.as_json},
      :notification_preferences => notification_preferences.to_a.map{|x| x.as_json},
      :hospitals => hospitals.to_a.map{|x| x.as_json},
      :crontabs => crontabs.to_a.map{|x| x.as_json},
      :vehicle_washes => vehicle_washes.to_a.map{|x| x.as_json},
      :haircuts => haircuts.to_a.map{|x| x.as_json},
      :mechanics => mechanics.to_a.map{|x| x.as_json},
      :parks => parks.to_a.map{|x| x.as_json},
      :basketball_courts => basketball_courts.to_a.map{|x| x.as_json},
      :tennis_courts => tennis_courts.to_a.map{|x| x.as_json},
      :soccer_fields => soccer_fields.to_a.map{|x| x.as_json},
      :health_changes => health_changes.to_a.map{|x| x.as_json},
      :locks => locks.to_a.map{|x| x.as_json},
      :restaurant_dishes => restaurant_dishes.to_a.map{|x| x.as_json},
      :identity_files => identity_files.to_a.map{|x| x.as_json},
    })
  end
  
  def calculation_forms_available
    CalculationForm.where(identity_id: id, is_duplicate: false)
  end
  
  def last_weight
    weights.to_a.sort{ |a,b| b.measure_date <=> a.measure_date }.first
  end
  
  def next_birthday
    result = nil
    if !birthday.nil?
      result = Date.new(Date.today.year, birthday.month, birthday.day)
      if result < Date.today
        result = Date.new(Date.today.year + 1, birthday.month, birthday.day)
      end
    end
    result
  end
  
  def full_name
    Myp.appendstr(Myp.appendstr(name, middle_name), last_name)
  end
  
  def display
    result = name
    result = Myp.appendstr(result, middle_name)
    result = Myp.appendstr(result, last_name)
    result = Myp.appendstrwrap(result, nickname)
    result = Myp.appendstrwrap(result, display_note)
    if result.blank? && !user.nil?
      result = user.email
    end
    result
  end
  
  def self.order
    ["identities.name"]
  end
  
  def display_initials
    result = name[0]
    if !last_name.blank?
      result += last_name[0]
    elsif !middle_name.blank?
      result += middle_name[0]
    end
    result
  end
  
  def display_short
    result = nickname
    if result.blank? && !default_name?
      result = name
      if !last_name.blank?
        result += " " + last_name[0]
      end
    end
    if result.blank? && !user.nil?
      result = user.email
    end
    if result.blank?
      result = display
    end
    if result.blank?
      result = display_note
    end
    result
  end

  def self.calendar_item_display(calendar_item)
    identity = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.contacts.upcoming_birthday",
      name: identity.display,
      delta: Myp.time_delta(calendar_item.calendar_item_time)
    )
  end
  
  def self.calendar_item_link(calendar_item)
    Rails.application.routes.url_helpers.send("contact_path", calendar_item.find_model_object.contact)
  end
  
  def main_calendar
    self.calendars[0]
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    if ExecutionContext.count > 0 && MyplaceonlineExecutionContext.handle_updates? && !User.current_user.current_identity.nil?
      
      Rails.logger.debug{"Identity.on_after_save #{self}"}
      
      ApplicationRecord.transaction do
        on_after_destroy
        if !birthday.nil?
          User.current_user.current_identity.calendars.each do |calendar|
            
            t = next_birthday
            
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: t,
              reminder_threshold_amount: (calendar.birthday_threshold_seconds || DEFAULT_BIRTHDAY_THRESHOLD_SECONDS),
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id,
              repeat_amount: 1,
              repeat_type: Myp::TIME_DURATION_YEARS,
              context_info: Identity::CALENDAR_ITEM_CONTEXT_BIRTHDAY
            )
            
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: t + 12.hours,
              reminder_threshold_amount: 5.minutes.seconds,
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id,
              repeat_amount: 1,
              repeat_type: Myp::TIME_DURATION_YEARS,
              context_info: Identity::CALENDAR_ITEM_CONTEXT_BIRTHDAY
            )
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.current_identity,
      self.class,
      model_id: id,
      context_info: Identity::CALENDAR_ITEM_CONTEXT_BIRTHDAY
    )
  end
  
  def send_email?
    self.message_preferences.nil? || ((self.message_preferences & MESSAGE_PREFERENCE_EMAIL) != 0)
  end
  
  def send_text?
    self.message_preferences.nil? || ((self.message_preferences & MESSAGE_PREFERENCE_SMS) != 0)
  end
  
  def send_message(body_short_markdown, body_long_markdown, subject, reply_to: nil, cc: nil, bcc: nil)
    
    if self.send_email?
      Rails.logger.debug{"Identity.send_message sending emails"}
      body_long_html = Myp.markdown_to_html(body_long_markdown)
      self.send_email(subject, body_long_html, cc, bcc, body_long_markdown, reply_to)
    end
    
    if self.send_text?
      Rails.logger.debug{"Identity.send_message sending texts"}
      body_short_markdown = Myp.markdown_for_plain_email(body_short_markdown)
      self.send_sms(body: body_short_markdown)
    end
    
  end
  
  def send_email(subject, body, cc = nil, bcc = nil, body_plain = nil, reply_to = nil, use_secondary_for_reply_to: false)
    emails_processed = []
    self.emails.each do |email|
      Myp.send_email(email, subject, body, cc, bcc, body_plain, reply_to, use_secondary_for_reply_to: use_secondary_for_reply_to)
      emails_processed << email
    end
    if !user.nil? && !emails_processed.any?{|e| e == user.email }
      Myp.send_email(user.email, subject, body, cc, bcc, body_plain, reply_to, use_secondary_for_reply_to: use_secondary_for_reply_to)
    end
  end
  
  def phone_numbers
    identity_phones.to_a.map{|ip| ip.number }
  end
  
  def mobile_phone_numbers
    identity_phones.to_a.keep_if{|ip| ip.accepts_sms? }.map{|ip| ip.number }
  end
  
  def first_mobile_number
    result = identity_phones.to_a.index{|x| x.accepts_sms? }
    if !result.nil?
      result = identity_phones[result]
    end
    result
  end
  
  def has_mobile?
    identity_phones.any?{|identity_phone| identity_phone.accepts_sms?}
  end
  
  def send_sms(body:)
    result = false
    Rails.logger.info{"Identity.send_sms ID: #{self.id}"}
    self.mobile_phone_numbers.each do |phone_number|
      Rails.logger.info{"Identity.send_sm phone: #{phone_number}"}
      Myp.send_sms(to: phone_number, body: body)
      result = true
    end
    result
  end
  
  def final_search_result
    is_type_contact? ? contact : parent_company
  end
  
  def final_search_result_display?
    false
  end

  def self.param_names(include_website: true, recurse: true, include_company: true)
    Myp.combine_conditionally([
      :id,
      :_updatetype,
      :name,
      :middle_name,
      :last_name,
      :nickname,
      :birthday,
      :notes,
      :likes,
      :gift_ideas,
      :ktn,
      :sex_type,
      :new_years_resolution,
      :display_note,
      :identity_type,
      :blood_type,
      :message_preferences,
      :mens_shirt_neck_size,
      :mens_shirt_sleeve_length,
      :jacket_size,
      :shoe_size,
      :belt_size,
      :tshirt_size,
      :pants_waist,
      :pants_length,
      identity_phones_attributes: [
        :id,
        :number,
        :phone_type,
        :_destroy
      ],
      identity_emails_attributes: [
        :id,
        :_destroy,
        :email,
        :secondary
      ],
      identity_locations_attributes: [
        :id,
        :_destroy,
        :secondary,
        location_attributes: LocationsController.param_names(include_website: include_website, include_company: include_company)
      ],
      identity_drivers_licenses_attributes: [
        :id,
        :identifier,
        :expires,
        :region,
        :sub_region1,
        :_destroy,
        identity_file_attributes: FilesController.param_names
      ],
      identity_relationships_attributes: [
        :id,
        :relationship_type,
        :_destroy,
        contact_attributes:
          recurse ?
            ContactsController.param_names(include_website: include_website, recurse: false, include_company: include_company) :
            [
              :id,
              :_destroy
            ]
      ],
      identity_pictures_attributes: [
        :id,
        :_destroy,
        identity_file_attributes: FilesController.param_names
      ],
      identity_clothes_attributes: [
        :id,
        :_destroy,
        :clothes,
        :when_date,
      ],
    ], include_company) {[
      company_attributes: Company.param_names(include_website: include_website)
    ]}
  end

  def self.skip_check_attributes
    ["identity_type"]
  end
  
  def parent_company
    Company.where(company_identity_id: self.id).first!
  end
  
  def after_create
    self.ensure_contact!
    Myplet.default_myplets(self)
  end
  
  def find_connection_by_user(user)
    Connection.where(
      identity_id: self.id,
      connection_status: Connection::STATUS_CONNECTED,
      user: user,
    ).take
  end
end
