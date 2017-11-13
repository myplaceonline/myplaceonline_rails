class GenotypeCall < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  
  def self.properties
    [
    ]
  end
  
  # https://customercare.23andme.com/hc/en-us/articles/212196888-What-does-not-determined-or-not-genotyped-mean-
  ALLELE_TYPE_DELETION = -3
  ALLELE_TYPE_INSERTION = -2
  ALLELE_TYPE_NOT_DETERMINED = -1
  ALLELE_TYPE_THYMINE = 0
  ALLELE_TYPE_ADENINE = 1
  ALLELE_TYPE_GUANINE = 2
  ALLELE_TYPE_CYTOSINE = 3
  
  ORIENTATION_POSITIVE = 0
  ORIENTATION_NEGATIVE = 1

  belongs_to :snp
  belongs_to :dna_analysis

  def display
    self.snp.display
  end
  
  def self.searchable?
    false
  end
  
  def self.letter_to_type(letter)
    case letter
    when "T"
      GenotypeCall::ALLELE_TYPE_THYMINE
    when "A"
      GenotypeCall::ALLELE_TYPE_ADENINE
    when "G"
      GenotypeCall::ALLELE_TYPE_GUANINE
    when "C"
      GenotypeCall::ALLELE_TYPE_CYTOSINE
    when "-"
      GenotypeCall::ALLELE_TYPE_NOT_DETERMINED
    when "D"
      GenotypeCall::ALLELE_TYPE_DELETION
    when "I"
      GenotypeCall::ALLELE_TYPE_INSERTION
    else
      raise "Unknown letter #{letter} for #{line}"
    end
  end
end
