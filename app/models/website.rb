class Website < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :title, presence: true
  
  child_properties(name: :website_passwords)

  child_property(name: :recommender, model: Contact)

  def display
    title
  end

  def self.skip_check_attributes
    ["to_visit"]
  end
end
