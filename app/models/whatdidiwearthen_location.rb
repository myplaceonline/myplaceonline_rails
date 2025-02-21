class WhatdidiwearthenLocation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :location, type: ApplicationRecord::PROPERTY_TYPE_CHILD }
    ]
  end

  belongs_to :whatdidiwearthen
  child_property(name: :location)
end
