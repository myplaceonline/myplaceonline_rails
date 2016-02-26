class Concert < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :concert_date, presence: true
  validates :concert_title, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  has_many :concert_musical_groups, :dependent => :destroy
  accepts_nested_attributes_for :concert_musical_groups, allow_destroy: true, reject_if: :all_blank

  def display
    concert_title + " (" + Myp.display_date_short_year(concert_date, User.current_user) + ")"
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.concert_date = Date.today
    result
  end

  before_validation :update_pic_folders
    
  def update_pic_folders
    put_files_in_folder(concert_pictures, [I18n.t("myplaceonline.category.concerts"), display])
  end

  has_many :concert_pictures, :dependent => :destroy
  accepts_nested_attributes_for :concert_pictures, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :concert_pictures, [{:name => :identity_file}]
end
