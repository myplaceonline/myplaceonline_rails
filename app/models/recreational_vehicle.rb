class RecreationalVehicle < ActiveRecord::Base
  
  belongs_to :identity
  validates :rv_name, presence: true
  
  def display
    rv_name
  end

  belongs_to :location_purchased, class_name: Location, :autosave => true
  accepts_nested_attributes_for :location_purchased, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }

  # http://stackoverflow.com/a/12064875/4135310
  def location_purchased_attributes=(attributes)
    if !attributes['id'].blank?
      self.location_purchased = Location.find(attributes['id'])
    end
    super
  end

  has_many :recreational_vehicle_loans, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_loans, allow_destroy: true, reject_if: :all_blank

  has_many :recreational_vehicle_pictures, :dependent => :destroy
  accepts_nested_attributes_for :recreational_vehicle_pictures, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
