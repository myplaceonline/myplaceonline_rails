class WebsiteDomainSshKey < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website_domain

  child_property(name: :ssh_key)
end
