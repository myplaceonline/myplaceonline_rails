class Event < MyplaceonlineIdentityRecord

  validates :event_name, presence: true
  
  belongs_to :reminder
  accepts_nested_attributes_for :reminder, allow_destroy: true, reject_if: :all_blank

  def display
    event_name
  end
  
end
