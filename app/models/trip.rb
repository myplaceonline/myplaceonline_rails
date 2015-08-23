class Trip < MyplaceonlineIdentityRecord
  include AllowExistingConcern

  validates :location, presence: true
  validates :started, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  has_many :trip_pictures, :dependent => :destroy
  accepts_nested_attributes_for :trip_pictures, allow_destroy: true, reject_if: :all_blank
  
  before_validation :update_pic_folders
  
  def update_pic_folders
    folders = Array.new
    folders.push(I18n.t("myplaceonline.category.trips"))
    if !self.location.region_name.blank?
      folders.push(self.location.region_name)
    end
    if !self.location.sub_region1_name.blank?
      folders.push(self.location.sub_region1_name)
    end
    if !self.location.sub_region2.blank?
      folders.push(self.location.sub_region2)
    end
    if folders.length == 1
      if !self.location.display_general_region.blank?
        folders.push(self.location.display_general_region)
      end
    end
    put_pictures_in_folder(trip_pictures, folders)
  end
  
  def display
    result = Myp.display_date_short_year(started, User.current_user)
    if !ended.nil?
      result += " - " + Myp.display_date_short_year(ended, User.current_user)
    end
    result += " (" + location.display_simple + ")"
    if work
      result += " (" + I18n.t("myplaceonline.trips.work") + ")"
    end
    result
  end
end
