class Trek < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :location, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  def display
    location.display
  end

  before_validation :update_pic_folders
    
  def update_pic_folders
    put_files_in_folder(trek_pictures, [I18n.t("myplaceonline.category.treks"), display])
  end

  has_many :trek_pictures, :dependent => :destroy
  accepts_nested_attributes_for :trek_pictures, allow_destroy: true, reject_if: :all_blank
end
