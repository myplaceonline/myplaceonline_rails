class Story < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :story_name, presence: true
  validates :story_time, presence: true
  
  before_validation :update_pic_folders
  
  def update_pic_folders
    put_files_in_folder(story_pictures, [I18n.t("myplaceonline.category.stories"), display])
  end

  has_many :story_pictures, :dependent => :destroy
  accepts_nested_attributes_for :story_pictures, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :story_pictures, [{:name => :identity_file}]
  
  def display
    Myp.appendstrwrap(story_name, Myp.display_datetime_short(story_time, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.story_time = Time.now
    result
  end
end
