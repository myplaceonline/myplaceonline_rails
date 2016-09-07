class Event < ActiveRecord::Base
  include MyplaceonlineActiveRecordIdentityConcern
  include AllowExistingConcern
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  DEFAULT_EVENT_THRESHOLD_SECONDS = 1.days
  
  RSVP_YES = 1
  RSVP_MAYBE = 2
  RSVP_NO = 3

  validates :event_name, presence: true
  
  belongs_to :repeat
  accepts_nested_attributes_for :repeat, allow_destroy: true, reject_if: :all_blank

  belongs_to :location
  accepts_nested_attributes_for :location, reject_if: proc { |attributes| LocationsController.reject_if_blank(attributes) }
  allow_existing :location

  def display
    event_name
  end
  
  def additional_display
    if !self.event_time.nil?
      " @ " + Myp.display_date_short(self.event_time, User.current_user) + " " + Myp.display_time(self.event_time, User.current_user, :simple_time)
    else
      ""
    end
  end
  
  before_validation :update_pic_folders
  
  def update_pic_folders
    put_files_in_folder(event_pictures, [I18n.t("myplaceonline.category.events"), display])
  end

  has_many :event_pictures, -> { order("position ASC, updated_at ASC") }, :dependent => :destroy
  accepts_nested_attributes_for :event_pictures, allow_destroy: true, reject_if: :all_blank
  allow_existing_children :event_pictures, [{:name => :identity_file}]

  has_many :event_contacts, :dependent => :destroy
  accepts_nested_attributes_for :event_contacts, allow_destroy: true, reject_if: :all_blank

  has_many :event_rsvps, :dependent => :destroy

  def self.calendar_item_display(calendar_item)
    event = calendar_item.find_model_object
    I18n.t(
      "myplaceonline.events.upcoming",
      name: event.display,
      delta: Myp.time_delta(calendar_item.calendar_item_time)
    )
  end
  
  after_commit :on_after_save, on: [:create, :update]
  
  def on_after_save
    on_after_destroy
    if !event_time.nil?
      ActiveRecord::Base.transaction do
        User.current_user.primary_identity.calendars.each do |calendar|
          CalendarItem.create_calendar_item(
            User.current_user.primary_identity,
            calendar,
            self.class,
            event_time,
            (calendar.event_threshold_seconds || DEFAULT_EVENT_THRESHOLD_SECONDS),
            Calendar::DEFAULT_REMINDER_TYPE,
            model_id: id,
          )
        end
      end
    end
    Repeat.create_calendar_reminders(
      self,
      "event_threshold_seconds",
      DEFAULT_EVENT_THRESHOLD_SECONDS,
      Calendar::DEFAULT_REMINDER_TYPE,
      destroy: false,
      expire_amount: 1.days.seconds.to_i,
      expire_type: Calendar::DEFAULT_REMINDER_TYPE
    )
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.primary_identity,
      self.class,
      model_id: self.id
    )
  end

  def self.has_shared_page?
    true
  end
  
  def self.share_async?(permission_share)
    true
  end
  
  def self.execute_share(permission_share)
    begin
      User.current_user = permission_share.identity.user
      obj = Myp.find_existing_object!(permission_share.subject_class, permission_share.subject_id)
      obj.event_pictures.map{|x| x.identity_file}.each do |identity_file|
        psc = PermissionShareChild.new
        psc.identity = obj.identity
        psc.share = permission_share.share
        psc.subject_class = IdentityFile.name
        psc.subject_id = identity_file.id
        psc.permission_share = permission_share
        psc.save!
      end
      permission_share.send_email(obj)
    ensure
      User.current_user = nil
    end
  end
  
  def replace_email_html(result, target_email, target_contact, permission_share)
    
    email_token = EmailToken.find_or_create_by_email(target_email)

    result = "<p>#{I18n.t("myplaceonline.category.events").singularize}: " + ActionController::Base.helpers.link_to(self.display, Rails.application.routes.url_helpers.send("event_shared_url", self.id, Rails.configuration.default_url_options) + "?token=" + permission_share.share.token + "&email_token=" + email_token) + "</p>"
    
    if !self.event_time.nil?
      result += "\n<p>#{I18n.t("myplaceonline.events.event_time")}: #{Myp.display_datetime(self.event_time, User.current_user)}</p>"
    end
    
    if !self.event_end_time.nil?
      result += "\n<p>#{I18n.t("myplaceonline.events.event_end_time")}: #{Myp.display_datetime(self.event_end_time, User.current_user)}</p>"
    end
    
    if !self.location.nil?
      result += "\n<p>#{I18n.t("myplaceonline.events.location")}: #{ActionController::Base.helpers.link_to(self.location.address_one_line, self.location.map_url)}</p>"
    end
    
    rsvp_link = permission_share.link(suffix_path: "rsvp")
    
    result += "\n<hr /><p>#{I18n.t("myplaceonline.events.email_intro")}</p><p>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.events.rsvp_yes"), rsvp_link + "&type=#{Event::RSVP_YES}&email_token=#{email_token}")}&nbsp;|&nbsp;#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.events.rsvp_maybe"), rsvp_link + "&type=#{Event::RSVP_MAYBE}&email_token=#{email_token}")}&nbsp;|&nbsp;#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.events.rsvp_no"), rsvp_link + "&type=#{Event::RSVP_NO}&email_token=#{email_token}")}</p><hr />"

    if !self.notes.blank?
      result += "\n#{Myp.markdown_to_html(self.notes)}"
    end
    
    event_pictures.each do |x|
      result += "\n<hr />\n  <p>"
      result += ActionController::Base.helpers.image_tag(
        file_thumbnail_name_url(
          x.identity_file, x.identity_file.urlname, token: permission_share.share.token
        ),
        class: "fit"
      )
      result += "</p>"
      if !x.identity_file.notes.blank?
        result += "\n#{Myp.markdown_to_html(x.identity_file.notes)}"
      end
    end
    
    result
  end

  def replace_email_plain(result, target_email, target_contact, permission_share)

    email_token = EmailToken.find_or_create_by_email(target_email)

    result = "#{I18n.t("myplaceonline.category.events").singularize}: " + Rails.application.routes.url_helpers.send("event_shared_url", self.id, Rails.configuration.default_url_options) + "?token=" + permission_share.share.token + "&email_token=" + email_token + "\n\n"

    if !self.event_time.nil?
      result += "#{I18n.t("myplaceonline.events.event_time")}: #{Myp.display_datetime(self.event_time, User.current_user)}\n\n"
    end
    
    if !self.event_end_time.nil?
      result += "#{I18n.t("myplaceonline.events.event_end_time")}: #{Myp.display_datetime(self.event_end_time, User.current_user)}\n\n"
    end
    
    if !self.location.nil?
      result += "#{I18n.t("myplaceonline.events.location")}: #{self.location.address_one_line}\n#{I18n.t("myplaceonline.events.map")}: #{self.location.map_url}\n\n"
    end
    
    rsvp_link = permission_share.link(suffix_path: "rsvp")

    result += "=========\n\n#{I18n.t("myplaceonline.events.email_intro")}\n\n#{I18n.t("myplaceonline.events.rsvp_yes")}: #{rsvp_link + "&type=#{Event::RSVP_YES}&email_token=#{email_token}"}\n\n#{I18n.t("myplaceonline.events.rsvp_maybe")}: #{rsvp_link + "&type=#{Event::RSVP_MAYBE}&email_token=#{email_token}"}\n\n#{I18n.t("myplaceonline.events.rsvp_no")}: #{rsvp_link + "&type=#{Event::RSVP_NO}&email_token=#{email_token}"}\n\n=========\n\n"

    if !self.notes.blank?
      result += "#{self.notes}\n\n"
    end
    
    if event_pictures.count > 0
      result += "#{I18n.t("myplaceonline.events.pictures")}:\n=========\n"
      event_pictures.each do |x|
        result += "* " + file_thumbnail_name_url(
          x.identity_file, x.identity_file.urlname, token: permission_share.share.token
        ) + "\n"
        if !x.identity_file.notes.blank?
          result += "   #{x.identity_file.notes}\n"
        end
      end
    end

    result
  end
  
  def self.handle_new_reminder?
    true
  end
  
  def handle_new_reminder
    
    permission_share = PermissionShare.where(
      identity_id: self.identity_id,
      subject_class: Event.name,
      subject_id: self.id
    ).last
    
    if !permission_share.nil?
      
      event_rsvps.each do |event_rsvp|
        
        if event_rsvp.rsvp_type != Event::RSVP_NO
          html = replace_email_html("", event_rsvp.email, nil, permission_share)
          plain = replace_email_plain("", event_rsvp.email, nil, permission_share)
        
          Myp.send_email(
            event_rsvp.email,
            I18n.t("myplaceonline.events.rsvp_reminder_title", name: self.display),
            html.html_safe,
            nil,
            nil,
            plain,
            User.current_user.email
          )
        end
      end
    end
  end

  protected
  def default_url_options
    Rails.configuration.default_url_options
  end
end
