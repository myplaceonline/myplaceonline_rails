class FinancialAsset < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :asset_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :asset_value, type: ApplicationRecord::PROPERTY_TYPE_DECIMAL },
      { name: :quantity, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :asset_location, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :asset_received, type: ApplicationRecord::PROPERTY_TYPE_DATETIME },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :financial_asset_files, type: ApplicationRecord::PROPERTY_TYPE_FILES },
    ]
  end

  validates :asset_name, presence: true
  validates :asset_value, presence: true
  
  def display
    Myp.appendstrwrap(self.asset_name, self.asset_location)
  end
  
  def total_asset_value
    result = self.asset_value
    if !self.quantity.nil?
      result = result * self.quantity
    end
    return result
  end

  child_files
end
