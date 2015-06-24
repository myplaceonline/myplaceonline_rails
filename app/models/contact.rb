class Contact < ActiveRecord::Base

  CONTACT_TYPES = [
    ["myplaceonline.contacts.best_friend", 0],
    ["myplaceonline.contacts.good_friend", 1],
    ["myplaceonline.contacts.acquiantance", 2],
    ["myplaceonline.contacts.business_contact", 3],
    ["myplaceonline.contacts.best_family", 4],
    ["myplaceonline.contacts.good_family", 5]
  ]
  
  belongs_to :ref, class_name: Identity, :dependent => :destroy
  belongs_to :identity
  accepts_nested_attributes_for :ref, reject_if: :all_blank
  
  validate :custom_validation
  
  has_many :conversations, :dependent => :destroy
  accepts_nested_attributes_for :conversations, allow_destroy: true, reject_if: :all_blank
  
  def all_conversations
    Conversation.where(contact_id: id).order(["conversations.when DESC", "conversations.created_at DESC"])
  end
  
  def custom_validation
    if !contact_identity.nil? && contact_identity.name.blank?
      errors.add(:name, "not specified")
    end
  end

  def name
    contact_identity.name
  end
  
  def birthday
    contact_identity.birthday
  end
  
  def notes
    contact_identity.notes
  end
  
  def contact_identity
    ref
  end

  def as_json(options={})
    super.as_json(options).merge({
      :contact_identity => ref.as_json
    })
  end

  def display
    if !contact_identity.nil?
      name
    else
      I18n.t("myplaceonline.general.unknown")
    end
  end
  
  def self.build(params = nil)
    result = Contact.new(params)
    result.ref = Myp.new_model(Identity)
    result
  end
  
  before_create :do_before_save
  before_update :do_before_save

  def do_before_save
    Myp.set_common_model_properties(self)
  end
end
