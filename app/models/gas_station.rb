class GasStation < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :location, :autosave => true
  validates_presence_of :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  def display
    location.display
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.gas = true
    result
  end
end
