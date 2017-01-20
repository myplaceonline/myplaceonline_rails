class JobReview < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :job
  
  validates :review_date, presence: true

  child_property(name: :contact)

  child_files

  def file_folders_parent
    :job
  end

  def final_search_result
    job
  end
  
  def display
    Myp.display_date_short_year(review_date, User.current_user)
  end
end
