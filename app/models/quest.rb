class Quest < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :quest_title, presence: true
  
  def display
    quest_title
  end

  child_properties(name: :quest_files, sort: "position ASC, updated_at ASC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(quest_files, [I18n.t("myplaceonline.category.quests"), display])
  end

end
