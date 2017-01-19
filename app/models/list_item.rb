class ListItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :list
end
