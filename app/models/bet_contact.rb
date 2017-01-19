class BetContact < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :bet

  child_property(name: :contact, required: true)
end
