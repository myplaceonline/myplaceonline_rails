class BloodTest < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include AllowExistingConcern

  validates :test_time, presence: true
  
  def display
    Myp.display_datetime_short(test_time, User.current_user)
  end
  
  has_many :blood_test_results, :dependent => :destroy
  accepts_nested_attributes_for :blood_test_results, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :blood_test_results, [{:name => :blood_concentration}]

  has_many :blood_test_files, :dependent => :destroy
  accepts_nested_attributes_for :blood_test_files, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :blood_test_files, [{:name => :identity_file}]

  before_validation :update_file_folders
  
  def update_file_folders
    put_files_in_folder(blood_test_files, [I18n.t("myplaceonline.category.blood_tests"), display])
  end
end
