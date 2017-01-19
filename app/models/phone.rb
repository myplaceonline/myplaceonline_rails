class Phone < ApplicationRecord
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
  
  child_property(name: :manufacturer, model: Company)

  child_property(name: :password)

  before_validation :update_phone_files
  
  child_properties(name: :phone_files, sort: "position ASC, updated_at ASC")

  def update_phone_files
    put_files_in_folder(phone_files, [I18n.t("myplaceonline.category.phones"), display])
  end

  def self.skip_check_attributes
    ["hyperthreaded", "cdma", "gsm"]
  end
end
