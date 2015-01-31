class Movie < ActiveRecord::Base
  belongs_to :identity
  validates :name, presence: true
  attr_accessor :is_watched
end
