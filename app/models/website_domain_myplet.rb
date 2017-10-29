class WebsiteDomainMyplet < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website_domain

  child_property(name: :category)
  
  validates :category, presence: true
  validates :website_domain, presence: true

  def display
    category.display
  end
end
