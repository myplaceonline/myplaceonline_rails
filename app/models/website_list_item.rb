class WebsiteListItem < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  belongs_to :website_list

  belongs_to :website
  accepts_nested_attributes_for :website, reject_if: proc { |attributes| WebsitesController.reject_if_blank(attributes) }
  allow_existing :website
end
