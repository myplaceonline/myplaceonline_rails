class WhatdidiwearthenFile < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  def self.properties
    [
      { name: :identity_file, type: ApplicationRecord::PROPERTY_TYPE_CHILD }
    ]
  end

  child_file(parent: :whatdidiwearthen)
end
