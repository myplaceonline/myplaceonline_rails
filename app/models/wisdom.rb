class Wisdom < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :name, presence: true
  
  def display
    name
  end

  has_many :wisdom_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :wisdom_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :wisdom_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(wisdom_files, [I18n.t("myplaceonline.category.wisdoms"), display])
  end
end
