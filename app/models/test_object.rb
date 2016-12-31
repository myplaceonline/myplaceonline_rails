class TestObject < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :test_object_name, presence: true
  
  def display
    test_object_name
  end

  has_many :test_object_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :test_object_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :test_object_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(test_object_files, [I18n.t("myplaceonline.category.test_objects"), display])
  end
end
