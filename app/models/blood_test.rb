class BloodTest < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include AllowExistingConcern

  validates :test_time, presence: true
  
  def display
    Myp.display_datetime_short_year(test_time, User.current_user)
  end
  
  child_properties(name: :blood_test_results)

  child_properties(name: :blood_test_files, sort: "position ASC, updated_at ASC")

  child_property(name: :location)

  child_property(name: :doctor)

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(blood_test_files, [I18n.t("myplaceonline.category.blood_tests"), display])
  end
end
