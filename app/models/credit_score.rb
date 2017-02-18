class CreditScore < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  validates :score_date, presence: true
  validates :score, presence: true
  
  def display
    Myp.appendstrwrap(Myp.appendstrwrap(Myp.display_date(score_date, User.current_user), score), source)
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.score_date = Date.today
    result
  end
  
  child_files
end
