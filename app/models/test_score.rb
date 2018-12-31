class TestScore < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern

  validates :test_score_name, presence: true
  
  def display
    result = Myp.appendstrwrap(test_score_name, test_score)
    if !self.percentile.nil?
      result = Myp.appendstrwrap(result, self.percentile.ordinalize + " " + I18n.t("myplaceonline.test_scores.percentile"))
    end
    result
  end

  child_files
end
