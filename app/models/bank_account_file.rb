class BankAccountFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :identity_file, type: ApplicationRecord::PROPERTY_TYPE_CHILD }
    ]
  end

  child_file(parent: :bank_account)
end
