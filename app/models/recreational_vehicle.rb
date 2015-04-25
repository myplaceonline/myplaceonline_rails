class RecreationalVehicle < ActiveRecord::Base
  
  belongs_to :identity
  validates :rv_name, presence: true

  belongs_to :location_purchased, class_name: Location, :autosave => true
  accepts_nested_attributes_for :location_purchased, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }

  # http://stackoverflow.com/a/12064875/4135310
  def location_purchased_attributes=(attributes)
    if !attributes['id'].blank?
      self.location_purchased = Location.find(attributes['id'])
    end
    super
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
