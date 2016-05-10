class Bet < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :bet_name, presence: true
  validates :bet_amount, presence: true
  
  def display
    bet_name
  end
end
