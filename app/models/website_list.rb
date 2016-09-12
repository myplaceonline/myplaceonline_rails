class WebsiteList < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :website_list_name, presence: true
  
  def display
    website_list_name
  end
end
