class TestObjectInstance < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :test_object_instance_name, type: ApplicationRecord::PROPERTY_TYPE_STRING },
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
    ]
  end

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
