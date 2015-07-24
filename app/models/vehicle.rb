class Vehicle < ActiveRecord::Base
  
  ENGINE_TYPES = [["myplaceonline.vehicles.gas", 0], ["myplaceonline.vehicles.diesel", 1]]
  DISPLACEMENT_TYPES = [["myplaceonline.vehicles.litres", 0]]
  DOOR_TYPES = [["myplaceonline.vehicles.doors_standard", 0], ["myplaceonline.vehicles.doors_extended", 1], ["myplaceonline.vehicles.doors_crew", 2]]
  DRIVE_TYPES = [["myplaceonline.vehicles.front_wheel_drive", 0], ["myplaceonline.vehicles.rear_wheel_drive", 1]]
  WHEEL_TYPES = [["myplaceonline.vehicles.single_rear_wheel", 0], ["myplaceonline.vehicles.dual_rear_wheels", 1]]
  
  belongs_to :owner, class_name: Identity
  validates :name, presence: true

  has_many :vehicle_loans, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_loans, allow_destroy: true, reject_if: :all_blank

  has_many :vehicle_services, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_services, allow_destroy: true, reject_if: :all_blank
  
  has_many :vehicle_insurances, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_insurances, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def vehicle_insurances_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['company_attributes'].blank? && !value['company_attributes']['id'].blank? && value['_destroy'] != "1"
        self.vehicle_insurances.each{|x|
          if !x.company.nil? && x.company.id == value['company_attributes']['id'].to_i
            x.company = Company.find(value['company_attributes']['id'])
          end
        }
      end
      if !value['periodic_payment_attributes'].blank? && !value['periodic_payment_attributes']['id'].blank? && value['_destroy'] != "1"
        self.vehicle_insurances.each{|x|
          if !x.periodic_payment.nil? && x.periodic_payment.id == value['periodic_payment_attributes']['id'].to_i
            x.periodic_payment = PeriodicPayment.find(value['periodic_payment_attributes']['id'])
          end
        }
      end
    }
  end
  
  belongs_to :recreational_vehicle, :autosave => true
  accepts_nested_attributes_for :recreational_vehicle, reject_if: proc { |attributes| RecreationalVehiclesController.reject_if_blank(attributes) }

  # http://stackoverflow.com/a/12064875/4135310
  def recreational_vehicle_attributes=(attributes)
    if !attributes['id'].blank?
      self.recreational_vehicle = RecreationalVehicle.find(attributes['id'])
    end
    super
  end

  has_many :vehicle_pictures, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_pictures, allow_destroy: true, reject_if: :all_blank
  
  has_many :vehicle_warranties, :dependent => :destroy
  accepts_nested_attributes_for :vehicle_warranties, allow_destroy: true, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def vehicle_warranties_attributes=(attributes)
    super(attributes)
    attributes.each {|key, value|
      if !value['warranty_attributes'].blank? && !value['warranty_attributes']['id'].blank? && value['_destroy'] != "1"
        self.vehicle_warranties.each{|x|
          if x.warranty.id == value['warranty_attributes']['id'].to_i
            x.warranty = Warranty.find(value['warranty_attributes']['id'])
          end
        }
      end
    }
  end

  def display
    Myp.appendstrwrap(name, license_plate)
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
