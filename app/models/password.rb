class Password < ActiveRecord::Base
  
  validates :name, presence: true
  validates :password, presence: true
  
  belongs_to :identity
end
