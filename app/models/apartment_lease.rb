class ApartmentLease < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :apartment

  child_properties(name: :apartment_lease_files, sort: "position ASC, updated_at ASC")
  
  def display
    apartment.display
  end

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(apartment_lease_files, [I18n.t("myplaceonline.apartments.apartment_leases"), display])
  end
end
