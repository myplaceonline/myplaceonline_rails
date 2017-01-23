class TestScore < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :test_score_name, presence: true
  
  def display
    test_score_name
  end

  child_files
end
