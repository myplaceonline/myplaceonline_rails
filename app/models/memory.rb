class Memory < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :memory_name, presence: true
  
  def display
    memory_name
  end

  child_files
end
