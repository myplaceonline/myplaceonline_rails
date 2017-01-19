class Story < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :story_name, presence: true
  validates :story_time, presence: true
  
  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(story_pictures, [I18n.t("myplaceonline.category.stories"), display])
  end

  child_properties(name: :story_pictures)
  
  def display
    Myp.appendstrwrap(story_name, Myp.display_datetime_short(story_time, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.story_time = Time.now
    result
  end

  def self.skip_check_attributes
    ["story_time"]
  end
end
