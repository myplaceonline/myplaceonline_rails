class Medicine < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  child_files
  
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
      :dosage_type,
      medicine_files_attributes: FilesController.multi_param_names,
    ]
  end
end
