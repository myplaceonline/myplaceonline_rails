class Passport < MyplaceonlineIdentityRecord
  validates :region, presence: true
  validates :passport_number, presence: true
  
  def display
    region + " (" + passport_number + ")"
  end
  
  has_many :passport_pictures, :dependent => :destroy
  accepts_nested_attributes_for :passport_pictures, allow_destroy: true, reject_if: :all_blank
end
