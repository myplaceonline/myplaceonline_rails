class AlertsDisplay < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  def display
    id.to_s
  end
end
