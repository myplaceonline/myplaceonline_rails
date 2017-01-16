class Donation < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :donation_name, presence: true
  
  belongs_to :location, :autosave => true
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }

  def display
    donation_name
  end

  has_many :donation_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :donation_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :donation_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(donation_files, [I18n.t("myplaceonline.category.donations"), display])
  end
end
