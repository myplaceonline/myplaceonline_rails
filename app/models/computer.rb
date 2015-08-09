class Computer < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :owner, class_name: Identity
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
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
