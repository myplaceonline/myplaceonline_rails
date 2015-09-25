class Group < MyplaceonlineIdentityRecord
  validates :group_name, presence: true
  
  has_many :group_contacts, :dependent => :destroy
  accepts_nested_attributes_for :group_contacts, allow_destroy: true, reject_if: :all_blank

  def display
    group_name
  end
end
