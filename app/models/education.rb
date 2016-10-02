class Education < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :education_name, presence: true
  #validates :education_end, presence: true
  
  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  def display
    Myp.appendstrwrap(education_name, degree_name)
  end

  has_many :education_files, :dependent => :destroy
  accepts_nested_attributes_for :education_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :education_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(education_files, [I18n.t("myplaceonline.category.educations"), display])
  end
end
