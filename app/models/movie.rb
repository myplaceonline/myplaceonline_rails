class Movie < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern
  include AllowExistingConcern

  validates :name, presence: true
  attr_accessor :is_watched
  boolean_time_transfer :is_watched, :watched
  
  child_property(name: :recommender, model: Contact)

  child_property(name: :lent_to, model: Contact)
  
  child_property(name: :borrowed_from, model: Contact)

  def display
    name
  end

  def self.skip_check_attributes
    ["is_watched"]
  end
end
