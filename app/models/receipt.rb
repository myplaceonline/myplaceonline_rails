class Receipt < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :receipt_name, presence: true
  validates :receipt_time, presence: true
  
  child_files

  def display
    Myp.appendstrwrap(receipt_name, Myp.display_datetime_short(receipt_time, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    # initialize result here
    result.receipt_time = Time.now
    result
  end
end
