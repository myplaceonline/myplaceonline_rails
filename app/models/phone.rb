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

  before_validation :update_phone_files
  
  has_many :phone_files, :dependent => :destroy
  accepts_nested_attributes_for :phone_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :phone_files, [{:name => :identity_file}]

  def update_phone_files
    put_files_in_folder(phone_files, [I18n.t("myplaceonline.category.phones"), display])
  end
end
