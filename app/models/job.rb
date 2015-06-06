class Job < ActiveRecord::Base
  belongs_to :identity
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
  
  # http://stackoverflow.com/a/12064875/4135310
  def company_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.company = Company.find(attributes['id'])
    end
    super
  end

  belongs_to :manager_contact, class_name: Contact
  accepts_nested_attributes_for :manager_contact, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def company_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.company = Company.find(attributes['id'])
    end
    super
  end

  has_many :job_salaries, -> { order('started DESC') }, :dependent => :destroy
  accepts_nested_attributes_for :job_salaries, allow_destroy: true, reject_if: :all_blank

  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
