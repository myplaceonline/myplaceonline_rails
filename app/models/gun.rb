class Gun < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :gun_name, presence: true
  
  child_properties(name: :gun_registrations)
  
  child_files

  def display
    gun_name
  end
end
