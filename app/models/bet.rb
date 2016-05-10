class Bet < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

  validates :bet_name, presence: true
  validates :bet_amount, presence: true
  
  has_many :bet_contacts, :dependent => :destroy
  accepts_nested_attributes_for :bet_contacts, allow_destroy: true, reject_if: :all_blank

  def display
    Myp.appendstrwrap(bet_name, Myp.display_date_short_year(bet_end_date, User.current_user))
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    result.bet_start_date = User.current_user.date_now
    result.odds_direction_owner = true
    result
  end
end
