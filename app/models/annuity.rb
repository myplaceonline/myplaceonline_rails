class Annuity < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :annuity_name, presence: true
  
  def display
    annuity_name
  end
end
