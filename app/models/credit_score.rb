class CreditScore < MyplaceonlineActiveRecord
  validates :score_date, presence: true
  validates :score, presence: true
  
  def display
    Myp.display_date(score_date, User.current_user) + " (" + score.to_s + ")"
  end
end
