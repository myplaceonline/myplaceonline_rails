class Website < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :title, presence: true
  
  has_many :website_passwords
  accepts_nested_attributes_for :website_passwords, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :website_passwords, [{:name => :password}]

  def display
    title
  end
end
