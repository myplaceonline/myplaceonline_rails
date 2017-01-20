class TestObject < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :test_object_name, presence: true
  
  def display
    test_object_name
  end

  child_files
end
