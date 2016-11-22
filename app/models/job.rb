class Job < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :job_title, presence: true
  
  def display
    result = job_title
    if !company.nil?
      result += " @ " + company.display
    end
    result
  end
  
  belongs_to :company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :company

  belongs_to :manager_contact, class_name: Contact
  accepts_nested_attributes_for :manager_contact, reject_if: proc { |attributes| ContactsController.reject_if_blank(attributes) }
  allow_existing :manager_contact, Contact

  has_many :job_salaries, -> { order('started DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :job_salaries, allow_destroy: true, reject_if: :all_blank

  belongs_to :internal_address, class_name: Location
  accepts_nested_attributes_for :internal_address, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :internal_address, Location

  has_many :job_managers, :dependent => :destroy
  accepts_nested_attributes_for :job_managers, allow_destroy: true, reject_if: :all_blank

  has_many :job_reviews, -> { order('review_date DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :job_reviews, allow_destroy: true, reject_if: :all_blank

  has_many :job_myreferences, :dependent => :destroy
  accepts_nested_attributes_for :job_myreferences, allow_destroy: true, reject_if: :all_blank

  has_many :job_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :job_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :job_files, [{:name => :identity_file}]

  has_many :job_accomplishments, -> { order('accomplishment_time DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :job_accomplishments, allow_destroy: true, reject_if: :all_blank

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(job_files, [I18n.t("myplaceonline.category.jobs"), display])
  end
end
