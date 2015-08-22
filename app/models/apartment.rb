class Apartment < MyplaceonlineActiveRecord
  include AllowExistingConcern

  belongs_to :location, :autosave => true
  validates_presence_of :location
  accepts_nested_attributes_for :location, reject_if: :all_blank
  allow_existing :location

  belongs_to :landlord, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :landlord, reject_if: :all_blank
  allow_existing :landlord, Contact

  has_many :apartment_leases, :dependent => :destroy
  accepts_nested_attributes_for :apartment_leases, allow_destroy: true, reject_if: :all_blank

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :landlord => landlord.as_json
    })
  end
  
  has_many :apartment_pictures, :dependent => :destroy
  accepts_nested_attributes_for :apartment_pictures, allow_destroy: true, reject_if: :all_blank

  def display
    location.display
  end
end
