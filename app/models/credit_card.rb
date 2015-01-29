class CreditCard < ActiveRecord::Base
  belongs_to :password
  belongs_to :identity
  validates :name, presence: true
  validates :number, presence: true
  validates :expires, presence: true
  validates :security_code, presence: true
end
