class Website < ActiveRecord::Base
  belongs_to :identity
  validates :url, presence: true
end
