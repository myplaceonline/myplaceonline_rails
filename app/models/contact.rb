class Contact < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern

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
  
  belongs_to :contact_identity, class_name: Identity, :dependent => :destroy
  accepts_nested_attributes_for :contact_identity
  
  validate :custom_validation
  
  has_many :conversations, :dependent => :destroy
  accepts_nested_attributes_for :conversations, allow_destroy: true, reject_if: :all_blank
  
  before_destroy :check_if_user_contact, prepend: true
  
  def check_if_user_contact
    if contact_identity_id == User.current_user.primary_identity.id
      raise "Cannot delete own identity"
    end
  end
  
  def all_conversations
    Conversation.where(contact_id: id).order(["conversations.conversation_date DESC"])
  end
  
  def custom_validation
    if !contact_identity.nil? && contact_identity.name.blank?
      errors.add(:name, "not specified")
    end
  end
  
  def as_json(options={})
    super.as_json(options).merge({
      :contact_identity => contact_identity.as_json
    })
  end

  def display
    if !contact_identity.nil?
      result = contact_identity.name
      whitespace = result =~ /\s+/
      if whitespace.nil?
        if !contact_identity.nickname.blank?
          result = Myp.appendstrwrap(result, contact_identity.nickname)
        end
        # Seemingly no last name, so add some other identifier if available
        if contact_identity.identity_relationships.length > 0 && !contact_identity.identity_relationships[0].relationship_name.nil?
          relationship = contact_identity.identity_relationships[0]
          result = Myp.appendstrwrap(result, I18n.t("myplaceonline.contacts.related_to") + " " + relationship.contact.contact_identity.name)
        end
      end
      result
    else
      I18n.t("myplaceonline.general.unknown")
    end
  end
  
  def self.build(params = nil)
    result = self.dobuild(params)
    result.contact_identity = Myp.new_model(Identity)
    result
  end
  
  before_validation :update_pic_folders
  
  def update_pic_folders
    if !contact_identity.nil?
      put_files_in_folder(contact_identity.identity_pictures, [I18n.t("myplaceonline.category.contacts"), display])
    end
  end
  
  def send_email(subject, body, cc = nil, bcc = nil)
    to = contact_identity.emails
    if to.length > 0
      Myp.send_email(to, subject, body, cc, bcc)
    end
  end

  after_save { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_UPDATE) }
  after_destroy { |record| DueItem.due_contacts(User.current_user, record, DueItem::UPDATE_TYPE_DELETE) }
end
