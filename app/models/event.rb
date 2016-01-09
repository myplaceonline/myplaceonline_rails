class Event < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :event_name, presence: true
  
  belongs_to :repeat
  accepts_nested_attributes_for :repeat, allow_destroy: true, reject_if: :all_blank

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  def display
    event_name
  end
  
  after_save { |record| DueItem.due_events(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_events(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }

  before_validation :update_pic_folders
  
  def update_pic_folders
    put_files_in_folder(event_pictures, [I18n.t("myplaceonline.category.events"), display])
  end

  has_many :event_pictures, :dependent => :destroy
  accepts_nested_attributes_for :event_pictures, allow_destroy: true, reject_if: :all_blank
end
