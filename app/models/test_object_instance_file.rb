class TestObjectInstanceFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :test_object_instance)
end
