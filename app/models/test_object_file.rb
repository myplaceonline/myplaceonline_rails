class TestObjectFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :test_object

  child_property(name: :identity_file, required: true)
end
