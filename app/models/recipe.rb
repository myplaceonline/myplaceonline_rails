class Recipe < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :name, presence: true
  
  def display
    name
  end

  before_validation :update_pic_folders
  
  def update_pic_folders
    put_files_in_folder(recipe_pictures, [I18n.t("myplaceonline.category.recipes"), display])
  end

  has_many :recipe_pictures, :dependent => :destroy
  accepts_nested_attributes_for :recipe_pictures, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :recipe_pictures, [{:name => :identity_file}]
end
