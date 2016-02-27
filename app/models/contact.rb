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
    ["myplaceonline.contacts.party_friend", 8],
    ["myplaceonline.contacts.dog", 9],
    ["myplaceonline.contacts.cat", 10]
  ]
  
  SEX_TYPES = [
    ["myplaceonline.contacts.sex_female", 0],
    ["myplaceonline.contacts.sex_male", 1]
  ]
  
  DEFAULT_CONTACT_BEST_FRIEND_THRESHOLD_SECONDS = 20.days
  DEFAULT_CONTACT_GOOD_FRIEND_THRESHOLD_SECONDS = 45.days
  DEFAULT_CONTACT_ACQUAINTANCE_THRESHOLD_SECONDS = 90.days
  DEFAULT_CONTACT_BEST_FAMILY_THRESHOLD_SECONDS = 20.days
  DEFAULT_CONTACT_GOOD_FAMILY_THRESHOLD_SECONDS = 45.days

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
      result = contact_identity.display
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
      if !contact_identity.company.nil?
        result = Myp.appendstrwrap(result, contact_identity.company.display)
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

  def self.contact_type_threshold(calendar)
    result = Hash.new
    result[0] = (calendar.contact_best_friend_threshold_seconds || DEFAULT_CONTACT_BEST_FRIEND_THRESHOLD_SECONDS)
    result[1] = (calendar.contact_good_friend_threshold_seconds || DEFAULT_CONTACT_GOOD_FRIEND_THRESHOLD_SECONDS)
    result[2] = (calendar.contact_acquaintance_threshold_seconds || DEFAULT_CONTACT_ACQUAINTANCE_THRESHOLD_SECONDS)
    result[4] = (calendar.contact_best_family_threshold_seconds || DEFAULT_CONTACT_BEST_FAMILY_THRESHOLD_SECONDS)
    result[5] = (calendar.contact_good_family_threshold_seconds || DEFAULT_CONTACT_GOOD_FAMILY_THRESHOLD_SECONDS)
    result
  end
  
  def last_conversation_date
    result = ActiveRecord::Base.connection.select_one(%{
      select max(conversation_date)
      from conversations
      where identity_id = #{identity.id}
            and contact_id = #{id}
    })["max"]
    if !result.blank?
      result = result.to_date
    end
    result
  end

  def self.calendar_item_display(calendar_item)
    contact = calendar_item.find_model_object
    if calendar_item.persistent
      I18n.t(
        "myplaceonline.contacts.no_conversations",
        name: contact.display,
        contact_type: Myp.get_select_name(contact.contact_type, Contact::CONTACT_TYPES)
      )
    else
      I18n.t(
        "myplaceonline.contacts.no_conversations_since",
        name: contact.display,
        contact_type: Myp.get_select_name(contact.contact_type, Contact::CONTACT_TYPES),
        delta: Myp.time_delta(contact.last_conversation_date)
      )
    end
  end
  
  def self.calendar_item_link(calendar_item)
    contact = calendar_item.find_model_object
    "/contacts/#{contact.id}/conversations/new"
  end

  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    ActiveRecord::Base.transaction do
      # Always destroy first because if the contact was updated to not
      # be of the type to have a conversation reminder, then we need to
      # delete any persistent reminders
      on_after_destroy
      if !contact_type.nil?
        User.current_user.primary_identity.calendars.each do |calendar|
          contact_threshold = Contact.contact_type_threshold(calendar)[contact_type]
          if !contact_threshold.nil?
            last = last_conversation_date
            if last.nil?
              CalendarItem.create_persistent_calendar_item(
                User.current_user.primary_identity,
                calendar,
                Contact,
                model_id: id,
                context_info: Conversation::CALENDAR_ITEM_CONTEXT_CONVERSATION
              )
            else
              next_conversation = last + contact_threshold.seconds
              CalendarItem.create_calendar_item(
                User.current_user.primary_identity,
                calendar,
                Contact,
                next_conversation,
                Calendar::DEFAULT_REMINDER_AMOUNT,
                Calendar::DEFAULT_REMINDER_TYPE,
                model_id: id,
                context_info: Conversation::CALENDAR_ITEM_CONTEXT_CONVERSATION
              )
            end
          end
        end
      end
    end
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.primary_identity,
      Contact,
      model_id: id,
      context_info: Conversation::CALENDAR_ITEM_CONTEXT_CONVERSATION
    )
  end
end
