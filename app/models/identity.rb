class Identity < MyplaceonlineModelBase
  belongs_to :owner, class_name: User
  has_many :passwords, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :identity_files, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :category_points_amounts, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :movies, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :wisdoms, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :to_dos, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :contacts, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :accomplishments, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :feeds, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :locations, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :activities, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :apartments, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :jokes, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :companies, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :promises, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :subscriptions, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :credit_scores, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :websites, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :credit_cards, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :bank_accounts, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :ideas, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :lists, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :calculation_forms, :foreign_key => 'owner_id', :dependent => :destroy
  
  def calculation_forms_available
    CalculationForm.where(owner_id: id, is_duplicate: false)
  end
  
  has_many :calculations, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :vehicles, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :questions, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :weights, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :blood_pressures, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :heart_rates, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :recipes, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :sleep_measurements, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :heights, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :meals, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :recreational_vehicles, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :acne_measurements, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :exercises, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :sun_exposures, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :medicine_usages, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :pains, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :songs, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :blood_tests, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :checklists, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :medical_conditions, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :life_goals, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :temperatures, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :headaches, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :skin_treatments, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :periodic_payments, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :jobs, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :trips, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :passports, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :promotions, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :reward_programs, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :computers, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :life_insurances, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :diary_entries, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :restaurants, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :camp_locations, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :guns, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :desired_products, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :books, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :favorite_products, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :therapists, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :health_insurances, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :doctors, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :dental_insurances, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :hobbies, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :poems, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :musical_groups, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :dentist_visits, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :doctor_visits, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :statuses, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :notepads, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :myplaceonline_searches, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :myplaceonline_quick_category_displays, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :myplaceonline_due_displays, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :concerts, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :shopping_lists, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :groups, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :phones, :foreign_key => 'owner_id', :dependent => :destroy
  has_many :movie_theaters, :foreign_key => 'owner_id', :dependent => :destroy
  
  has_many :myplets, -> { order('y_coordinate') }, :foreign_key => 'owner_id', :dependent => :destroy
  accepts_nested_attributes_for :myplets, allow_destroy: true, reject_if: :all_blank

  has_many :identity_phones, :foreign_key => 'identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_phones, allow_destroy: true, reject_if: :all_blank
  
  has_many :identity_emails, :foreign_key => 'identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_emails, allow_destroy: true, reject_if: :all_blank
  
  has_many :identity_locations, :foreign_key => 'identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_locations, allow_destroy: true, reject_if: :all_blank
  
  def primary_location
    identity_locations.first
  end
  
  has_many :identity_drivers_licenses, :foreign_key => 'identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_drivers_licenses, allow_destroy: true, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  
  has_many :identity_relationships, :foreign_key => 'identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_relationships, allow_destroy: true, reject_if: :all_blank
  
  has_many :identity_pictures, :foreign_key => 'identity_id', :dependent => :destroy
  accepts_nested_attributes_for :identity_pictures, allow_destroy: true, reject_if: :all_blank
  
  def as_json(options={})
    super.as_json(options).merge({
      :category_points_amounts => category_points_amounts.to_a.map{|x| x.as_json},
      :passwords => passwords.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :movies => movies.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :wisdoms => wisdoms.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :to_dos => to_dos.to_a.sort{ |a,b| a.short_description.downcase <=> b.short_description.downcase }.map{|x| x.as_json},
      :contacts => contacts.to_a.delete_if{|x| x.identity_id == id }.map{|x| x.as_json},
      :accomplishments => accomplishments.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :feeds => feeds.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :locations => locations.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :activities => activities.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :apartments => apartments.to_a.map{|x| x.as_json},
      :jokes => jokes.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :companies => companies.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :promises => promises.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
      :subscriptions => subscriptions.to_a.sort{ |a,b| a.name.downcase <=> b.name.downcase }.map{|x| x.as_json},
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
      :phones => phones.to_a.sort{ |a,b| a.model_name.downcase <=> b.model_name.downcase }.map{|x| x.as_json},
      :movie_theaters => movie_theaters.to_a.sort{ |a,b| a.theater_name.downcase <=> b.theater_name.downcase }.map{|x| x.as_json},
      :identity_files => identity_files.to_a.map{|x| x.as_json}
    })
  end
  
  def ensure_contact!
    result = Contact.find_by(
      owner_id: id,
      identity_id: id
    )
    if result.nil?
      ActiveRecord::Base.transaction do
        result = Contact.new
        if self.name.blank?
          self.name = I18n.t("myplaceonline.contacts.me")
          self.save!
        end
        result.owner = self
        result.identity = self
        result.save!
      end
    end
    result
  end
  
  def last_weight
    weights.to_a.sort{ |a,b| b.measure_date <=> a.measure_date }.first
  end
end
