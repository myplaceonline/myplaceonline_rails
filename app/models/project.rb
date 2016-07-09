class Project < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :project_name, presence: true
  
  has_many :project_issues, -> { order('position ASC') }, :dependent => :destroy
  accepts_nested_attributes_for :project_issues, allow_destroy: true, reject_if: :all_blank

  def display
    project_name
  end
end
