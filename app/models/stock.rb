class Stock < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :num_shares, presence: true
  
  def display
    Myp.appendstrwrap(company.display, num_shares.to_s)
  end
  
  belongs_to :company
  accepts_nested_attributes_for :company, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :company
  validates :company, presence: true

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
  
  after_save { |record| DueItem.due_stocks_vest(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_stocks_vest(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
