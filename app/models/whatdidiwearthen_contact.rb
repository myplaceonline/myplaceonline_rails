class WhatdidiwearthenContact < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :contact, type: ApplicationRecord::PROPERTY_TYPE_CHILD }
    ]
  end

  belongs_to :whatdidiwearthen
  child_property(name: :contact)
end
