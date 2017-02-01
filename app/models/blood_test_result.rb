class BloodTestResult < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :blood_test

  child_property(name: :blood_concentration, required: true)

  FLAGS = [
    ["myplaceonline.blood_test_results.flags.negative", 1],
    ["myplaceonline.blood_test_results.flags.positive", 2],
    ["myplaceonline.blood_test_results.flags.yellow", 3],
    ["myplaceonline.blood_test_results.flags.clear", 4],
    ["myplaceonline.blood_test_results.flags.nonreactive", 5],
    ["myplaceonline.blood_test_results.flags.reactive", 6],
    ["myplaceonline.blood_test_results.flags.normal", 7],
    ["myplaceonline.blood_test_results.flags.few", 8],
    ["myplaceonline.blood_test_results.flags.moderate", 9],
  ]

  def self.skip_check_attributes
    ["flag"]
  end
end
