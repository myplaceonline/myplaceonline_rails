class WebsiteDomainMyplet < ApplicationRecord
  belongs_to :website_domain
  belongs_to :category
  belongs_to :identity
end
