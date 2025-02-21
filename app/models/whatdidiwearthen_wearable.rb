class WhatdidiwearthenWearable < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :wearable, type: ApplicationRecord::PROPERTY_TYPE_CHILD }
    ]
  end

  belongs_to :whatdidiwearthen
  child_property(name: :wearable)
end
