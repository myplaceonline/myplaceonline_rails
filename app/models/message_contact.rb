class MessageContact < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :email

  child_property(name: :contact, required: true)
end
