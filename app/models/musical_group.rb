class MusicalGroup < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern

  validates :musical_group_name, presence: true
  
  attr_accessor :is_listened_to
  boolean_time_transfer :is_listened_to, :listened
  
  def display
    musical_group_name
  end

  def self.params
    [
      :id,
      :_destroy,
      :musical_group_name,
      :notes,
      :is_listened_to,
      :rating,
      :awesome,
      :secret,
      :musical_genre
    ]
  end

  def self.skip_check_attributes
    ["is_listened_to", "awesome", "secret"]
  end
end
