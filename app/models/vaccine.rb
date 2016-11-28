class Vaccine < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :vaccine_name, presence: true
  
  def display
    vaccine_name
  end

  has_many :vaccine_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :vaccine_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :vaccine_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(vaccine_files, [I18n.t("myplaceonline.category.vaccines"), display])
  end
end