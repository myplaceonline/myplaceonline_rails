class Warranty < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :warranty_name, presence: true

  child_files
  
  def display
    warranty_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :warranty_name,
      :warranty_start,
      :warranty_end,
      :warranty_condition,
      :notes,
      warranty_files_attributes: FilesController.multi_param_names
    ]
  end
end
