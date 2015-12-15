class CompleteDueItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :myplaceonline_due_display
end
