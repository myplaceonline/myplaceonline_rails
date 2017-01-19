class AdminTextMessage < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  child_property(name: :text_message, required: true)
end
