class WebsiteDomainMypletParameter < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website_domain_myplet

  validates :name, presence: true
  validates :val, presence: true

  def display
    self.name
  end

  def self.params
    [
      :id,
      :_destroy,
      :name,
      :val,
    ]
  end
end
