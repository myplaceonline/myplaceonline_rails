class Apartment < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :location, :autosave => true
  validates_presence_of :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  belongs_to :landlord, class_name: Contact, :autosave => true
  accepts_nested_attributes_for :landlord, reject_if: :all_blank
  allow_existing :landlord, Contact

  has_many :apartment_leases, :dependent => :destroy
  accepts_nested_attributes_for :apartment_leases, allow_destroy: true, reject_if: :all_blank

  has_many :apartment_trash_pickups, :dependent => :destroy
  accepts_nested_attributes_for :apartment_trash_pickups, allow_destroy: true, reject_if: :all_blank

  def as_json(options={})
    super.as_json(options).merge({
      :location => location.as_json,
      :landlord => landlord.as_json
    })
  end
  
  has_many :apartment_pictures, :dependent => :destroy
  accepts_nested_attributes_for :apartment_pictures, allow_destroy: true, reject_if: :all_blank

  before_validation :update_pic_folders
  
  def update_pic_folders
    put_pictures_in_folder(apartment_pictures, [I18n.t("myplaceonline.category.apartments"), display])
  end

  def display
    location.display
  end
end
