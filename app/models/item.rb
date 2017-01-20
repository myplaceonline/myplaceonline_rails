class Item < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :item_name, presence: true
  
  def display
    item_name
  end

  child_files
end
