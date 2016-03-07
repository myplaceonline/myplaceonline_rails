class Computer < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :computer_model, presence: true
  
  def display
    result = nil
    if !manufacturer.nil?
      result = Myp.appendstr(result, manufacturer.display)
    end
    result = Myp.appendstr(result, computer_model)
    result
  end
  
  belongs_to :manufacturer, class_name: Company
  accepts_nested_attributes_for :manufacturer, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :manufacturer, Company

  belongs_to :administrator, class_name: Password
  accepts_nested_attributes_for :administrator, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :administrator, Password
  
  belongs_to :main_user, class_name: Password
  accepts_nested_attributes_for :main_user, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :main_user, Password

  has_many :computer_ssh_keys, :dependent => :destroy
  accepts_nested_attributes_for :computer_ssh_keys, allow_destroy: true, reject_if: :all_blank
end
