class Gun < MyplaceonlineIdentityRecord
  validates :gun_name, presence: true
  
  has_many :gun_registrations, :dependent => :destroy
  accepts_nested_attributes_for :gun_registrations, allow_destroy: true, reject_if: :all_blank

  def display
    gun_name
  end

  after_save { |record| DueItem.due_gun_registrations(User.current_user) }
  after_destroy { |record| DueItem.due_gun_registrations(User.current_user) }
end
