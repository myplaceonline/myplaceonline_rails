class Apartment < ActiveRecord::Base
  belongs_to :owner, class: Identity

  belongs_to :location, :autosave => true
  validates_presence_of :location
  accepts_nested_attributes_for :location, reject_if: :all_blank

  # http://stackoverflow.com/a/12064875/4135310
  def location_attributes=(attributes)
    if !attributes['id'].blank?
      self.location = Location.find(attributes['id'])
    end
    super
  end

  belongs_to :landlord, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :landlord, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def landlord_attributes=(attributes)
    if !attributes['id'].blank?
      self.landlord = Contact.find(attributes['id'])
    end
    super
  end

  has_many :apartment_leases, :dependent => :destroy
  accepts_nested_attributes_for :apartment_leases, allow_destroy: true, reject_if: :all_blank

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :landlord => landlord.as_json
    })
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
