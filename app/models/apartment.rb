class Apartment < ActiveRecord::Base
  belongs_to :identity

  belongs_to :location
  validates_presence_of :location
  accepts_nested_attributes_for :location, reject_if: :all_blank

  # http://stackoverflow.com/a/12064875/4135310
  def location_attributes=(attributes)
    if attributes['id'].present?
      self.location = Location.find(attributes['id'])
    end
    super
  end

  belongs_to :landlord, class_name: Contact
  accepts_nested_attributes_for :landlord, reject_if: :all_blank
  
  # http://stackoverflow.com/a/12064875/4135310
  def landlord_attributes=(attributes)
    if attributes['id'].present?
      self.landlord = Contact.find(attributes['id'])
    end
    super
  end

  has_many :apartment_leases, :dependent => :destroy
  accepts_nested_attributes_for :apartment_leases, allow_destroy: true, reject_if: :all_blank
  
  validates_each :location, :landlord do |record, attr, value|
    Myp.authorize_value(record, attr, value)
  end

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :landlord => landlord.as_json
    })
  end
end
