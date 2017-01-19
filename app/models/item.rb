class Item < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :item_name, presence: true
  
  def display
    item_name
  end

  child_properties(name: :item_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(item_files, [I18n.t("myplaceonline.category.items"), display])
  end
end
