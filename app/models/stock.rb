class Stock < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :num_shares, presence: true
  
  def display
    company.display
  end
  
  belongs_to :company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :company
  validates :company, presence: true

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
end
