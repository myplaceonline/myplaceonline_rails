class Joke < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :name, presence: true
  
  def display
    name
  end
end
