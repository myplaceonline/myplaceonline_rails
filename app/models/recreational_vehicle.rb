class RecreationalVehicle < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
  validates :rv_name, presence: true
  
  def display
    rv_name
  end

  belongs_to :location_purchased, class_name: Location, :autosave => true
  accepts_nested_attributes_for :location_purchased, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location_purchased, Location

  has_many :recreational_vehicle_loans, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_loans, allow_destroy: true, reject_if: :all_blank

  has_many :recreational_vehicle_pictures, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_pictures, allow_destroy: true, reject_if: :all_blank

  has_many :recreational_vehicle_insurances, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_insurances, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def recreational_vehicle_insurances_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['company_attributes'].blank? && !value['company_attributes']['id'].blank? && value['_destroy'] != "1"
        self.recreational_vehicle_insurances.each{|x|
          if !x.company.nil? && x.company.id == value['company_attributes']['id'].to_i
            x.company = Company.find(value['company_attributes']['id'])
          end
        }
      end
      if !value['periodic_payment_attributes'].blank? && !value['periodic_payment_attributes']['id'].blank? && value['_destroy'] != "1"
        self.recreational_vehicle_insurances.each{|x|
          if !x.periodic_payment.nil? && x.periodic_payment.id == value['periodic_payment_attributes']['id'].to_i
            x.periodic_payment = PeriodicPayment.find(value['periodic_payment_attributes']['id'])
          end
        }
      end
    }
  end
  
  has_many :recreational_vehicle_measurements, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_measurements, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
