class TextMessageGroup < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :email

  child_property(name: :group)
end
