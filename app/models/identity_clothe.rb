class IdentityClothe < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :parent_identity, class_name: "Identity"
  
  validates :clothes, presence: true
  validates :when_date, presence: true

  def display
    self.clothes
  end
end
