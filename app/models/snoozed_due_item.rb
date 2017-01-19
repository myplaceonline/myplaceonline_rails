class SnoozedDueItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :calendar
end
