class WebsiteDomain < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :domain_name, presence: true
  validates :website, presence: true

  belongs_to :website
  accepts_nested_attributes_for :website, reject_if: proc { |attributes| WebsitesController.reject_if_blank(attributes) }
  allow_existing :website

  belongs_to :domain_host, class_name: Membership, :autosave => true
  accepts_nested_attributes_for :domain_host, reject_if: proc { |attributes| MembershipsController.reject_if_blank(attributes) }
  allow_existing :domain_host, Membership
  
  has_many :website_domain_ssh_keys, :dependent => :destroy
  accepts_nested_attributes_for :website_domain_ssh_keys, allow_destroy: true, reject_if: :all_blank

  def display
    domain_name
  end
end
