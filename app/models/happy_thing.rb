class HappyThing < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :happy_thing_name, presence: true
  
  def display
    happy_thing_name
  end
end
