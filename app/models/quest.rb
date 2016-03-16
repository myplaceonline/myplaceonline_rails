class Quest < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :quest_title, presence: true
  
  def display
    quest_title
  end
end
