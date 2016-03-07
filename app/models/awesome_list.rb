class AwesomeList < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :location, presence: true

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location
  
  has_many :awesome_list_items, :dependent => :destroy
  accepts_nested_attributes_for :awesome_list_items, allow_destroy: true, reject_if: :all_blank
  
  def display
    location.display
  end
end
