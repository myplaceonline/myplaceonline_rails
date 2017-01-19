class WebsiteListItem < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website_list

  child_property(name: :website)
end
