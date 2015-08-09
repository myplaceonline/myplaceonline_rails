class BloodTestResult < ActiveRecord::Base
  include AllowExistingConcern

  belongs_to :blood_test

  belongs_to :blood_concentration
  accepts_nested_attributes_for :blood_concentration, allow_destroy: true, reject_if: :all_blank
  allow_existing :blood_concentration

  belongs_to :owner, class_name: Identity
end
