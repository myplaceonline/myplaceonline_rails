class ApartmentLease < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :apartment

  has_many :apartment_lease_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :apartment_lease_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :apartment_lease_files, [{:name => :identity_file}]
  
  def display
    apartment.display
  end

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(apartment_lease_files, [I18n.t("myplaceonline.apartments.apartment_leases"), display])
  end
end
