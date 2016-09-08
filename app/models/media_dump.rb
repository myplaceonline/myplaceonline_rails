class MediaDump < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :media_dump_name, presence: true

  has_many :media_dump_files, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :media_dump_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :media_dump_files, [{:name => :identity_file}]
  
  before_validation :update_pic_folders
  
  def update_pic_folders
    put_files_in_folder(media_dump_files, [I18n.t("myplaceonline.category.media_dumps"), display])
  end
  
  def display
    media_dump_name
  end
end
