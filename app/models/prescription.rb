class Prescription < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :prescription_name, presence: true
  
  belongs_to :doctor
  accepts_nested_attributes_for :doctor, reject_if: proc { |attributes| DoctorsController.reject_if_blank(attributes) }
  allow_existing :doctor
  
  has_many :prescription_refills, -> { order('refill_date DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :prescription_refills, allow_destroy: true, reject_if: :all_blank

  def display
    prescription_name
  end

  has_many :prescription_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :prescription_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :prescription_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(prescription_files, [I18n.t("myplaceonline.category.prescriptions"), display])
  end
end
