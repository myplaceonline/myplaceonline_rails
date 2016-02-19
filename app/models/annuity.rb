class Annuity < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :annuity_name, presence: true
  
  def display
    annuity_name
  end
end
