class JobAward < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern

  belongs_to :job
  
  validates :job_award_description, presence: true

  def display
    Myp.appendstrwrap(self.job_award_description, Myp.number_to_currency(self.job_award_amount))
  end
end
