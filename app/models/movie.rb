class Movie < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern
  include AllowExistingConcern

  MEDIA_TYPES = [
    ["myplaceonline.movies.media_types.bluray", 0],
    ["myplaceonline.movies.media_types.dvd", 1],
  ]

  validates :name, presence: true
  attr_accessor :is_watched
  boolean_time_transfer :is_watched, :watched
  
  child_property(name: :recommender, model: Contact)

  child_property(name: :lent_to, model: Contact)
  
  child_property(name: :borrowed_from, model: Contact)

  boolean_time_transfer :is_owned, :when_owned
  
  boolean_time_transfer :is_discarded, :when_discarded

  def display
    name
  end

  def self.skip_check_attributes
    ["is_watched", "is_owned", "is_discarded"]
  end
end
