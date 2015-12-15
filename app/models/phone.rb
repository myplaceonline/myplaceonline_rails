class Phone < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  OPERATING_SYSTEMS = [
    ["myplaceonline.phones.operating_system_android", 0],
    ["myplaceonline.phones.operating_system_ios", 1],
    ["myplaceonline.phones.operating_system_windows", 2]
  ]

  validates :phone_model_name, presence: true
  
  def display
    result = nil
    if !manufacturer.nil?
      result = Myp.appendstr(result, manufacturer.display)
    end
    result = Myp.appendstr(result, phone_model_name)
    result
  end
  
  belongs_to :manufacturer, class_name: Company
  accepts_nested_attributes_for :manufacturer, reject_if: proc { |attributes| CompaniesController.reject_if_blank(attributes) }
  allow_existing :manufacturer, Company

  belongs_to :password
  accepts_nested_attributes_for :password, reject_if: proc { |attributes| PasswordsController.reject_if_blank(attributes) }
  allow_existing :password
end
