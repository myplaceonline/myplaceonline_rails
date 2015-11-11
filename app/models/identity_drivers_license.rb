class IdentityDriversLicense < MyplaceonlineIdentityRecord
  belongs_to :identity, class_name: Identity
  
  validates :identifier, presence: true

  belongs_to :identity_file, :dependent => :destroy
  accepts_nested_attributes_for :identity_file, allow_destroy: true, reject_if: :all_blank

  def display
    identifier
  end

  after_save { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
