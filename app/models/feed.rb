class Feed < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true
  validates :url, presence: true
end
