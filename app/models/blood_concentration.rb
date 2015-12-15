class BloodConcentration < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :concentration_name, presence: true
  
  def display
    concentration_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :concentration_name,
      :concentration_type,
      :concentration_minimum,
      :concentration_maximum
    ]
  end
end
