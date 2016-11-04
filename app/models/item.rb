class Item < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :item_name, presence: true
  
  def display
    item_name
  end

  has_many :item_files, :dependent => :destroy
  accepts_nested_attributes_for :item_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :item_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(item_files, [I18n.t("myplaceonline.category.items"), display])
  end
end
