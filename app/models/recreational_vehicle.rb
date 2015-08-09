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
  allow_existing_children :recreational_vehicle_insurances, [{:name => :company}, {:name => :periodic_payment}]
  
  has_many :recreational_vehicle_measurements, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_measurements, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
