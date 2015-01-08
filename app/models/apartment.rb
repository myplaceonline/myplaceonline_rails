class Apartment < ActiveRecord::Base
  belongs_to :identity

  belongs_to :location
  validates_presence_of :location
  accepts_nested_attributes_for :location

  belongs_to :landlord, class_name: Contact
  accepts_nested_attributes_for :landlord
  
  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :landlord => landlord.as_json
    })
  end
end
