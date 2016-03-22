class Timing < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :timing_name, presence: true
  
  has_many :timing_events, :dependent => :destroy
  accepts_nested_attributes_for :timing_events, allow_destroy: true, reject_if: :all_blank

  def display
    timing_name
  end
end
