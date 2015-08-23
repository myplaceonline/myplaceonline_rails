class Job < MyplaceonlineIdentityRecord
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
end
