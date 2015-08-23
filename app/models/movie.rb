class Movie < MyplaceonlineIdentityRecord
  include ModelHelpersConcern

  validates :name, presence: true
  attr_accessor :is_watched
  boolean_time_transfer :is_watched, :watched
  
  def display
    name
  end
end
