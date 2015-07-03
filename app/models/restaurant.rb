class Restaurant < ActiveRecord::Base
  belongs_to :identity

  validates :location, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def location_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.location = Location.find(attributes['id'])
    end
    super
  end
  
  def display
    location.display
  end

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
