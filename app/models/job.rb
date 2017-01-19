class Job < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :job_title, presence: true
  
  def display
    result = job_title
    if !company.nil?
      result += " @ " + company.display
    end
    result
  end
  
  child_property(name: :company)

  child_property(name: :manager_contact, model: Contact)

  child_properties(name: :job_salaries, sort: "started DESC")

  child_property(name: :internal_address, model: Location)

  child_properties(name: :job_managers)

  child_properties(name: :job_reviews, sort: "review_date DESC")

  child_properties(name: :job_myreferences)

  child_properties(name: :job_files, sort: "position ASC, updated_at ASC")

  child_properties(name: :job_accomplishments, sort: "accomplishment_time DESC")

  after_commit :update_file_folders, on: [:create, :update]
  
  def update_file_folders
    put_files_in_folder(job_files, [I18n.t("myplaceonline.category.jobs"), display])
  end
end
