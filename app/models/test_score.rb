class TestScore < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :test_score_name, presence: true
  
  def display
    Myp.appendstrwrap(test_score_name, test_score)
  end

  child_files
end
