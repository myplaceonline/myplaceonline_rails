class CreditScore < ActiveRecord::Base
  belongs_to :identity
  validates :score_date, presence: true
  validates :score, presence: true
  
  def display
    Myp.display_date(score_date, User.current_user) + " (" + score.to_s + ")"
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
