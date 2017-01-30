class Patent < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :patent_name, presence: true
  
  def display
    if self.patent_number.blank?
      Myp.appendstrwrap(self.patent_name, self.patent_number)
    else
      Myp.appendstrwrap(self.patent_number, Myp.ellipses_if_needed(self.patent_name, 32))
    end
  end

  def region_name
    if !region.blank?
      Carmen::Country.coded(region).official_name
    else
      nil
    end
  end
  
  def link
    if !self.patent_number.blank? && !self.region.blank?
      "https://patents.google.com/patent/" + self.region + self.patent_number
    else
      nil
    end
  end
  
  child_files
end
