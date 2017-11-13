class GenotypeCall < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  def self.properties
    [
    ]
  end

  belongs_to :snp
  belongs_to :dna_analysis

  def display
    self.snp.display
  end
  
  def self.searchable?
    false
  end
end
