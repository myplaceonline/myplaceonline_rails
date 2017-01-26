class Donation < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :donation_name, presence: true
  
  child_property(name: :location)

  def display
    Myp.appendstrwrap(donation_name, Myp.display_currency(self.amount))
  end

  child_files
end
