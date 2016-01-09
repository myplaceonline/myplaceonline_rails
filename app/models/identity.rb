class Identity < ActiveRecord::Base
  include MyplaceonlineActiveRecordBaseConcern

  belongs_to :user
  has_many :passwords, :dependent => :destroy
  has_many :identity_files, :dependent => :destroy
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
  has_many :myplaceonline_due_displays, :dependent => :destroy
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
  
  has_many :myplets, -> { order('y_coordinate') }, :dependent => :destroy
  accepts_nested_attributes_for :myplets, allow_destroy: true, reject_if: :all_blank

  has_many :identity_phones, :foreign_key => 'parent_identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_phones, allow_destroy: true, reject_if: :all_blank
  
  has_many :identity_emails, :foreign_key => 'parent_identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_emails, allow_destroy: true, reject_if: :all_blank
  
  def emails
    identity_emails.to_a.map{|ie| ie.email }
  end
  
  has_many :identity_locations, :foreign_key => 'parent_identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_locations, allow_destroy: true, reject_if: :all_blank
  
  def primary_location
    identity_locations.first
  end
  
  has_many :identity_drivers_licenses, :foreign_key => 'parent_identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_drivers_licenses, allow_destroy: true, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  
  has_many :identity_relationships, :foreign_key => 'parent_identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_relationships, allow_destroy: true, reject_if: :all_blank
  
  has_many :identity_pictures, :foreign_key => 'parent_identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_pictures, allow_destroy: true, reject_if: :all_blank
  
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
      :myplaceonline_due_displays => myplaceonline_due_displays.to_a.map{|x| x.as_json},
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
      :identity_files => identity_files.to_a.map{|x| x.as_json}
    })
  end
  
  def calculation_forms_available
    CalculationForm.where(identity_id: id, is_duplicate: false)
  end
  
  def ensure_contact!
    result = Contact.find_by(
      identity_id: id,
      contact_identity_id: id
    )
    if result.nil?
      ActiveRecord::Base.transaction do
        result = Contact.new
        if self.name.blank?
          self.name = I18n.t("myplaceonline.contacts.me")
          self.save!
        end
        result.identity = self
        result.contact_identity = self
        result.save!
      end
    end
    result
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
  
  def display
    result = name
    if result.blank?
      result = user.email
    end
    result
  end
end
