class Apartment < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  child_property(name: :landlord, model: Contact)

  child_properties(name: :apartment_leases, sort: "start_date DESC")

  child_properties(name: :apartment_trash_pickups)

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :landlord => landlord.as_json
    })
  end
  
  child_pictures

  def display
    location.address_one_line
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.apartment_leases << ApartmentLease.new
    result
  end
  
  def latest_lease
    if apartment_leases.length > 0
      apartment_leases.first
    else
      nil
    end
  end
end
