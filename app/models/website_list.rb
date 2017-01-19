class WebsiteList < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :website_list_name, presence: true
  
  child_properties(name: :website_list_items, sort: "position ASC, updated_at ASC")

  def display
    website_list_name
  end

  def self.skip_check_attributes
    ["disable_autoload"]
  end
end
