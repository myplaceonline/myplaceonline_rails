class Hobby < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :hobby_name, presence: true
  
  def display
    hobby_name
  end
end
