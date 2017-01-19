class WebsitePassword < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website

  child_property(name: :password)

  validates :password, presence: true
end
