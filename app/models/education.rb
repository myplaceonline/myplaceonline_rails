class Education < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :education_name, presence: true
  #validates :education_end, presence: true
  
  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  def display
    Myp.appendstrwrap(education_name, degree_name)
  end
end
