class Poem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :poem_name, presence: true
  
  def display
    Myp.appendstrwrap(self.poem_name, self.poem_author)
  end
end
