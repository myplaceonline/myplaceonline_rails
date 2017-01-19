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
  
  child_properties(name: :apartment_pictures)

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(apartment_pictures, [I18n.t("myplaceonline.category.apartments"), display])
  end

  def display
    location.display
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
