class FavoriteProduct < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :product_name, presence: true
  
  has_many :favorite_product_links, :dependent => :destroy
  accepts_nested_attributes_for :favorite_product_links, allow_destroy: true, reject_if: :all_blank

  def display
    product_name
  end

  has_many :favorite_product_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :favorite_product_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :favorite_product_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(favorite_product_files, [I18n.t("myplaceonline.category.favorite_products"), display])
  end
end
