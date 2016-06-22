class Project < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :project_name, presence: true
  
  def display
    project_name
  end
end
