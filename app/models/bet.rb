class Bet < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :bet_name, presence: true
  validates :bet_amount, presence: true
  
  def display
    bet_name
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.odds_direction_owner = true
    result
  end
end
