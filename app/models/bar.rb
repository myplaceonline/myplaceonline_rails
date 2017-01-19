class Bar < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_property(name: :location, required: true)
  
  def display
    location.display
  end

  after_commit :update_file_folders, on: [:create, :update]
    
  def update_file_folders
    put_files_in_folder(bar_pictures, [I18n.t("myplaceonline.category.bars"), display])
  end

  child_properties(name: :bar_pictures)
end
