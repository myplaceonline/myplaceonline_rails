class FoodFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :food

  child_property(name: :identity_file, required: true)
end
