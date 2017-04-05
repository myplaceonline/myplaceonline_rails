class TestObject < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :test_object_name, presence: true
  
  def display
    test_object_name
  end

  child_files

  child_properties(name: :test_object_instances, sort: "test_object_instance_name ASC")

  child_property(name: :contact)
end
