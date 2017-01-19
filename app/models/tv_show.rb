class TvShow < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ModelHelpersConcern
  include AllowExistingConcern

  validates :tv_show_name, presence: true
  attr_accessor :is_watched
  boolean_time_transfer :is_watched, :watched
  
  child_property(name: :recommender, model: Contact)

  def display
    tv_show_name
  end

  def self.skip_check_attributes
    ["is_watched"]
  end
end
