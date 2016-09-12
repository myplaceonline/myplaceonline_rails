class WebsiteList < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :website_list_name, presence: true
  
  has_many :website_list_items, -> { order('position ASC') }, :dependent => :destroy
  accepts_nested_attributes_for :website_list_items, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :website_list_items, [{:name => :website}]

  def display
    website_list_name
  end
end
