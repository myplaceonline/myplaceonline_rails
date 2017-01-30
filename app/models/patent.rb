class Patent < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :patent_name, presence: true
  
  def display
    Myp.appendstrwrap(self.patent_name, self.patent_number)
  end

  def region_name
    if !region.blank?
      Carmen::Country.coded(region).official_name
    else
      nil
    end
  end
  
  child_files
end
