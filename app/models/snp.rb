# "If more than 1% of a population does not carry the same nucleotide at a
# specific position in the DNA sequence, then this variation can be classified
# as a SNP."
# https://www.nature.com/scitable/definition/single-nucleotide-polymorphism-snp-295
#
# "Allele: Traditional definition: alternate forms of a gene, composed of one or
# more SNPs. More loosely: a SNP. For example, at a given position along a
# chromosome, most people might have the DNA base "A". A few might have an
# alternative sequence. Each defined type is an allele."
# https://www.snpedia.com/index.php/Glossary
#
# https://ghr.nlm.nih.gov/primer/genomicresearch/snp
class Snp < ApplicationRecord
  include MyplaceonlineActiveRecordBaseConcern

  def self.properties
    [
      { name: :notes, type: ApplicationRecord::PROPERTY_TYPE_MARKDOWN },
      { name: :chromosome, type: ApplicationRecord::PROPERTY_TYPE_NUMBER },
      { name: :position, type: ApplicationRecord::PROPERTY_TYPE_NUMBER }, # also locus
    ]
  end

  SNP_TYPE_NCBI_RS = 0
  SNP_TYPE_23ANDME = 1

  ENUM = [
    ["myplaceonline.snps.snp_types.ncbi_rs", SNP_TYPE_NCBI_RS],
    ["myplaceonline.snps.snp_types.23andme", SNP_TYPE_23ANDME],
  ]

  validates :snp_uid, presence: true
  
  def display
    self.snp_uid
  end
  
  def self.searchable?
    false
  end
end
