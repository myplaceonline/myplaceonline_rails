class TestObjectInstance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :test_object
  
  validates :test_object_instance_name, presence: true
  
  def display
    test_object_instance_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :test_object_instance_name,
      :notes,
      test_object_instance_files_attributes: FilesController.multi_param_names
    ]
  end

  child_files

  def file_folders_parent
    :test_object
  end
end
