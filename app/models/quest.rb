class Quest < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :quest_title, presence: true
  
  def display
    quest_title
  end

  has_many :quest_files, :dependent => :destroy
  accepts_nested_attributes_for :quest_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :quest_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(quest_files, [I18n.t("myplaceonline.category.quests"), display])
  end

end
