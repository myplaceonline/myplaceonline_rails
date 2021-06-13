class Event < ApplicationRecord
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
  
  child_property(name: :repeat)

  child_property(name: :location)

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
  
  child_pictures

  child_properties(name: :event_contacts)

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
    Rails.logger.debug{"Event on_after_save"}
    if MyplaceonlineExecutionContext.handle_updates?
      Rails.logger.debug{"Processing event updates"}
      on_after_destroy
      if !event_time.nil?
        ApplicationRecord.transaction do
          User.current_user.current_identity.calendars.each do |calendar|
            CalendarItem.create_calendar_item(
              identity: User.current_user.current_identity,
              calendar: calendar,
              model: self.class,
              calendar_item_time: event_time,
              reminder_threshold_amount: (calendar.event_threshold_seconds || DEFAULT_EVENT_THRESHOLD_SECONDS),
              reminder_threshold_type: Calendar::DEFAULT_REMINDER_TYPE,
              model_id: id,
              expire_amount: 1.days.seconds.to_i,
              expire_type: Calendar::DEFAULT_REMINDER_TYPE,
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
  end
  
  after_commit :on_after_destroy, on: :destroy
  
  def on_after_destroy
    CalendarItem.destroy_calendar_items(
      User.current_user.current_identity,
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
    MyplaceonlineExecutionContext.do_semifull_context(permission_share.identity.user) do
      obj = Myp.find_existing_object!(permission_share.subject_class, permission_share.subject_id)
      obj.set_pictures_shareable(permission_share)
      permission_share.send_email(obj)
    end
  end
  
  def set_pictures_shareable(permission_share)
    # Pictures may have been added since the last share, so first we destroy any previous
    # picture shares and then reshare everything
    
    PermissionShareChild.where(
      identity_id: self.identity_id,
      share_id: permission_share.share_id,
      permission_share_id: permission_share.id,
      subject_class: IdentityFile.name
    ).destroy_all
    
    self.event_pictures.map{|x| x.identity_file}.each do |identity_file|
      psc = PermissionShareChild.new
      psc.identity_id = self.identity_id
      psc.share_id = permission_share.share_id
      psc.subject_class = IdentityFile.name
      psc.subject_id = identity_file.id
      psc.permission_share_id = permission_share.id
      psc.save!
    end
  end
  
  def replace_email_html(result, target_email, target_contact, permission_share)
    
    email_token = EmailToken.find_or_create_by_email(target_email)

    result = "<p>#{I18n.t("myplaceonline.category.events").singularize}: " + ActionController::Base.helpers.link_to(self.display, LinkCreator.url("event_shared", self.id) + "?token=" + permission_share.share.token + "&email_token=" + email_token) + "</p>"
    
    if !self.event_time.nil?
      result += "\n<p>#{I18n.t("myplaceonline.events.event_time")}: #{Myp.display_datetime(self.event_time, User.current_user)}</p>"
    end
    
    if !self.event_end_time.nil?
      result += "\n<p>#{I18n.t("myplaceonline.events.event_end_time")}: #{Myp.display_datetime(self.event_end_time, User.current_user)}</p>"
    end
    
    if !self.location.nil?
      result += "\n<p>#{I18n.t("myplaceonline.events.location")}: #{ActionController::Base.helpers.link_to(self.location.address_one_line, self.location.map_url)}</p>"
    end
    
    # We might be sharing out an email with pictures after the event, so if the event is completed, don't bother to add
    # an RSVP section. Also, if it's not completed, but the event is within a day, don't bother to give an RSVP either
    if !self.completed? && !Myp.within_a_day?(time: self.event_time)
      rsvp_link = permission_share.link(suffix_path: "rsvp")
      
      result += "\n<hr /><p>#{I18n.t("myplaceonline.events.email_intro")}</p><p>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.events.rsvp_yes"), rsvp_link + "&type=#{Event::RSVP_YES}&email_token=#{email_token}")}&nbsp;|&nbsp;#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.events.rsvp_maybe"), rsvp_link + "&type=#{Event::RSVP_MAYBE}&email_token=#{email_token}")}&nbsp;|&nbsp;#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.events.rsvp_no"), rsvp_link + "&type=#{Event::RSVP_NO}&email_token=#{email_token}")}</p><hr />"
    end

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

    result = "#{I18n.t("myplaceonline.category.events").singularize}: " + LinkCreator.url("event_shared", self.id) + "?token=" + permission_share.share.token + "&email_token=" + email_token + "\n\n"

    if !self.event_time.nil?
      result += "#{I18n.t("myplaceonline.events.event_time")}: #{Myp.display_datetime(self.event_time, User.current_user)}\n\n"
    end
    
    if !self.event_end_time.nil?
      result += "#{I18n.t("myplaceonline.events.event_end_time")}: #{Myp.display_datetime(self.event_end_time, User.current_user)}\n\n"
    end
    
    if !self.location.nil?
      result += "#{I18n.t("myplaceonline.events.location")}: #{self.location.address_one_line}\n#{I18n.t("myplaceonline.events.map")}: #{self.location.map_url}\n\n"
    end

    if !self.completed? && !Myp.within_a_day?(time: self.event_time)
      rsvp_link = permission_share.link(suffix_path: "rsvp")

      result += "=========\n\n#{I18n.t("myplaceonline.events.email_intro")}\n\n#{I18n.t("myplaceonline.events.rsvp_yes")}: #{rsvp_link + "&type=#{Event::RSVP_YES}&email_token=#{email_token}"}\n\n#{I18n.t("myplaceonline.events.rsvp_maybe")}: #{rsvp_link + "&type=#{Event::RSVP_MAYBE}&email_token=#{email_token}"}\n\n#{I18n.t("myplaceonline.events.rsvp_no")}: #{rsvp_link + "&type=#{Event::RSVP_NO}&email_token=#{email_token}"}\n\n=========\n\n"
    end

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
  
  def completed?
    !self.event_time.nil? && self.event_time < DateTime.now
  end
  
  def handle_new_reminder
    permission_share = PermissionShare.where(
      identity_id: self.identity_id,
      subject_class: Event.name,
      subject_id: self.id
    ).last
    
    if !permission_share.nil?
      
      self.set_pictures_shareable(permission_share)
      
      event_rsvps.each do |event_rsvp|
        # If the person RSVPed Yes or Maybe and this is a reminder for an upcoming
        # event, then send the reminder email. If the event already occurred,
        # then this reminder is probably popping because the event was edited to
        # add pictures or notes, so in that case, we email everyone (so that they
        # can get any pictures from the event)
        if event_rsvp.rsvp_type != Event::RSVP_NO || self.completed?
          html = replace_email_html("", event_rsvp.email, nil, permission_share)
          plain = replace_email_plain("", event_rsvp.email, nil, permission_share)
        
          Myp.send_email(
            event_rsvp.email,
            I18n.t(
                   (self.completed? ? "myplaceonline.events.rsvp_update_title" : "myplaceonline.events.rsvp_reminder_title"),
                   name: self.display
                  ),
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

  def self.category_split_button_link
    Rails.application.routes.url_helpers.send("#{self.table_name}_map_path")
  end
  
  def self.category_split_button_title
    I18n.t("myplaceonline.general.map")
  end

  def self.category_split_button_icon
    "navigation"
  end
end
