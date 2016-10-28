class Document < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :document_name, presence: true
  
  def display
    document_name
  end

  has_many :document_files, :dependent => :destroy
  accepts_nested_attributes_for :document_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :document_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(document_files, [I18n.t("myplaceonline.category.documents"), display])
  end
end
