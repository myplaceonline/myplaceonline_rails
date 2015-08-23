class MusicalGroup < MyplaceonlineIdentityRecord
  include ModelHelpersConcern

  validates :musical_group_name, presence: true
  
  attr_accessor :is_listened_to
  boolean_time_transfer :is_listened_to, :listened
  
  def display
    musical_group_name
  end
end
