class Medicine < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :medicine_name, presence: true
  
  def display
    medicine_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :medicine_name,
      :notes,
      :dosage,
      :dosage_type
    ]
  end
end
