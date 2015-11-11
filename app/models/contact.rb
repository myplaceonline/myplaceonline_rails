class Contact < MyplaceonlineIdentityRecord

  CONTACT_TYPES = [
    ["myplaceonline.contacts.best_friend", 0],
    ["myplaceonline.contacts.good_friend", 1],
    ["myplaceonline.contacts.acquiantance", 2],
    ["myplaceonline.contacts.business_contact", 3],
    ["myplaceonline.contacts.best_family", 4],
    ["myplaceonline.contacts.good_family", 5],
    ["myplaceonline.contacts.neighbor", 6],
    ["myplaceonline.contacts.former_neighbor", 7],
    ["myplaceonline.contacts.party_friend", 8]
  ]
  
  belongs_to :identity, :dependent => :destroy
  accepts_nested_attributes_for :identity, reject_if: :all_blank
  
  validate :custom_validation
  
  has_many :conversations, :dependent => :destroy
  accepts_nested_attributes_for :conversations, allow_destroy: true, reject_if: :all_blank
  
  before_destroy :check_if_user_contact, prepend: true
  
  def check_if_user_contact
    if identity_id == User.current_user.primary_identity.id
      raise "Cannot delete own identity"
    end
  end
  
  def all_conversations
    Conversation.where(contact_id: id).order(["conversations.conversation_date DESC"])
  end
  
  def custom_validation
    if !identity.nil? && identity.name.blank?
      errors.add(:name, "not specified")
    end
  end
  
  def as_json(options={})
    super.as_json(options).merge({
      :identity => identity.as_json
    })
  end

  def display
    if !identity.nil?
      result = identity.name
      whitespace = result =~ /\s+/
      if whitespace.nil?
        if !identity.nickname.blank?
          result = Myp.appendstrwrap(result, identity.nickname)
        end
        # Seemingly no last name, so add some other identifier if available
        if identity.identity_relationships.length > 0 && !identity.identity_relationships[0].relationship_name.nil?
          relationship = identity.identity_relationships[0]
          result = Myp.appendstrwrap(result, I18n.t("myplaceonline.contacts.related_to") + " " + relationship.contact.identity.name)
        end
      end
      result
    else
      I18n.t("myplaceonline.general.unknown")
    end
  end
  
  def self.build(params = nil)
    result = super(params)
    result.identity = Myp.new_model(Identity)
    result
  end
  
  before_validation :update_pic_folders
  
  def update_pic_folders
    if !identity.nil?
      put_pictures_in_folder(identity.identity_pictures, [I18n.t("myplaceonline.category.contacts"), display])
    end
  end

  after_save { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
