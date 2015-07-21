class Computer < ActiveRecord::Base
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
  
  # http://stackoverflow.com/a/12064875/4135310
  def manufacturer_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.manufacturer = Company.find(attributes['id'])
    end
    super
  end

  belongs_to :administrator, class_name: Password
  accepts_nested_attributes_for :administrator, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def administrator_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.administrator = Password.find(attributes['id'])
    end
    super
  end
  
  belongs_to :main_user, class_name: Password
  accepts_nested_attributes_for :main_user, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  
  # http://stackoverflow.com/a/12064875/4135310
  def main_user_attributes=(attributes)
    if !attributes['id'].blank?
      attributes.keep_if {|innerkey, innervalue| innerkey == "id" }
      self.main_user = Password.find(attributes['id'])
    end
    super
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
