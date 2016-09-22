class BloodTest < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include AllowExistingConcern

  validates :test_time, presence: true
  
  def display
    Myp.display_datetime_short_year(test_time, User.current_user)
  end
  
  has_many :blood_test_results, :dependent => :destroy
  accepts_nested_attributes_for :blood_test_results, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :blood_test_results, [{:name => :blood_concentration}]

  has_many :blood_test_files, :dependent => :destroy
  accepts_nested_attributes_for :blood_test_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :blood_test_files, [{:name => :identity_file}]

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  belongs_to :doctor
  accepts_nested_attributes_for :doctor, reject_if: proc { |attributes| DoctorsController.reject_if_blank(attributes) }
  allow_existing :doctor

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(blood_test_files, [I18n.t("myplaceonline.category.blood_tests"), display])
  end
end
