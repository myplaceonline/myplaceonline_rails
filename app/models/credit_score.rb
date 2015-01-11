class CreditScore < ActiveRecord::Base
  belongs_to :identity
  validates :score_date, presence: true
  validates :score, presence: true
end
