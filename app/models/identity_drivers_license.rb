class IdentityDriversLicense < MyplaceonlineActiveRecord
  belongs_to :identity, class_name: Identity
  
  validates :identifier, presence: true

  belongs_to :identity_file, :dependent => :destroy
  accepts_nested_attributes_for :identity_file, allow_destroy: true, reject_if: :all_blank

  def display
    identifier
  end
end
