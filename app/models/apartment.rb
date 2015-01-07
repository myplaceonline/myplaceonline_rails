class Apartment < ActiveRecord::Base
  belongs_to :location
  belongs_to :identity
  validates_presence_of :location
  accepts_nested_attributes_for :location
end
