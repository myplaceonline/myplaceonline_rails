class MerchantAccount < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :merchant_account_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :limit_daily, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :limit_monthly, type: ApplicationRecord::PROPERTY_TYPE_CURRENCY },
      { name: :currencies_accepted, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :ship_to_countries, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :test_object_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :merchant_account_name, presence: true
  
  def display
    merchant_account_name
  end

  child_files
end
