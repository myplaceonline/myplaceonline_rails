class FavoriteProduct < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :product_name, presence: true
  
  child_properties(name: :favorite_product_links)

  def display
    product_name
  end

  child_properties(name: :favorite_product_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(favorite_product_files, [I18n.t("myplaceonline.category.favorite_products"), display])
  end
end
