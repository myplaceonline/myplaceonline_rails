class List < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true

  child_properties(name: :list_items, foreign_key: "list_id")
  
  def display
    name
  end
end
