class AdminEmail < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  child_property(name: :email)
end
