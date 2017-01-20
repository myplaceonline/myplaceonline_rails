class PeriodicPaymentInstanceFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  child_file(parent: :periodic_payment_instance)
end
