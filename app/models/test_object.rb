class TestObject < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :test_object_name, presence: true
  
  def display
    test_object_name
  end

  child_properties(name: :test_object_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(test_object_files, [I18n.t("myplaceonline.category.test_objects"), display])
  end
end
