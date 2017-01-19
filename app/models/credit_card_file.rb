class CreditCardFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :credit_card

  child_property(name: :identity_file, required: true)
end
