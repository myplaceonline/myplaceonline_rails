class ToDo < ActiveRecord::Base
  belongs_to :identity
  validates :short_description, presence: true
end
