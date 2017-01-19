class Recipe < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :name, presence: true
  
  def display
    name
  end

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(recipe_pictures, [I18n.t("myplaceonline.category.recipes"), display])
  end

  child_properties(name: :recipe_pictures)
end
