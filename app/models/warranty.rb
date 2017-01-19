class Warranty < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :warranty_name, presence: true
  
  def display
    warranty_name
  end
  
  def self.params
    [
      :id,
      :_destroy,
      :warranty_name,
      :warranty_start,
      :warranty_end,
      :warranty_condition,
      :notes
    ]
  end
end
