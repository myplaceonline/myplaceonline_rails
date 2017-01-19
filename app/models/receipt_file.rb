class ReceiptFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :receipt

  validates :identity_file, presence: true

  child_property(name: :identity_file)
end
