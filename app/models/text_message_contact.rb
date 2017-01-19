class TextMessageContact < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :email

  validates :contact, presence: true

  child_property(name: :contact)
end
