class Contact < MyplaceonlineActiveRecord

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
          result = Myp.appendstrwrap(result, relationship.contact.identity.name + "'s " + relationship.relationship_name)
        end
      end
      result
    else
      I18n.t("myplaceonline.general.unknown")
    end
  end
  
  def self.build(params = nil)
    result = Contact.new(params)
    result.identity = Myp.new_model(Identity)
    result
  end
end
