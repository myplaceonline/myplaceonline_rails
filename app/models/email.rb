class Email < ApplicationRecord
  include MyplaceonlineActiveRecordIdentityConcern
  include ActionView::Helpers
  include ActionDispatch::Routing
  include Rails.application.routes.url_helpers

  validates :subject, presence: true
  #validates :body, presence: true
  validates :email_category, presence: true

  child_properties(name: :email_contacts)

  child_properties(name: :email_groups)

  child_properties(name: :email_personalizations)

  def display
    subject
  end

  validate do
    if !draft && email_contacts.length == 0 && email_groups.length == 0
      errors.add(:email_contacts, I18n.t("myplaceonline.permissions.requires_contacts"))
    end
  end
  
  def all_targets
    targets = {}

    email_contacts.each do |email_contact|
      email_contact.contact.contact_identity.emails.each do |identity_email|
        targets[identity_email] = email_contact.contact
      end
    end

    email_groups.each do |email_group|
      process_group(targets, email_group.group)
    end
    
    targets
  end
  
  def send_email(body2_html = nil, body2_plain = nil, target_obj = nil, permission_share = nil)

    content = Myp.markdown_to_html(body)
    if content.nil?
      content = ""
    end
    if !body2_html.nil?
      if !content.blank?
        content += "\n\n"
      end
      content += body2_html
    end
    
    content_plain = Myp.markdown_for_plain_email(body)
    if content_plain.nil?
      content_plain = ""
    end
    if !body2_plain.nil?
      if !content_plain.blank?
        content_plain += "\n\n"
      end
      content_plain += body2_plain
    end
    
    targets = all_targets

    targets.each do |target, contact|
      process_single_target(target, contact, content, content_plain, target_obj, permission_share)
    end
  end
  
  def process_single_target(target, contact = nil, content = nil, content_plain = nil, target_obj = nil, permission_share = nil)
    Rails.logger.info{"Email process_single_target target: #{target}"}
    if EmailUnsubscription.where(
        "email = ? and (category is null or category = ?) and (identity_id is null or identity_id = ?)",
        target,
        email_category,
        identity.id
      ).first.nil?
      
      if content.nil?
        content = Myp.markdown_to_html(body)
      end
      if content_plain.nil?
        content_plain = body
      end

      user_display = identity.display
    
      to_hash = {}
      cc_hash = {}
      bcc_hash = {}
      
      if use_bcc
        bcc_hash[target] = true
      else
        to_hash[target] = true
      end

      if copy_self
        bcc_hash[identity.user.email] = true
      end
      
      Rails.logger.info{"Email check: #{target}"}

      et = EmailToken.find_or_create_token_by_email(target, identity: identity)
      
      unsubscribe_all_link = unsubscribe_url(token: et.token)
      unsubscribe_category_link = unsubscribe_url(category: email_category, token: et.token)
      
      user_display_short = identity.display_short
      user_email = identity.user.email
      
      personalization = EmailPersonalization.where(target: target, identity: identity, email: self).first
      
      if personalization.nil? || personalization.do_send
        
        final_content = content

        if !personalization.nil? && !personalization.additional_text.blank?
          final_content += "\n\n" + Myp.markdown_to_html(personalization.additional_text)
        end
        
        if !target_obj.nil? && target_obj.respond_to?("add_email_html")
          final_content += target_obj.add_email_html(target, contact, permission_share)
        end
        
        if !target_obj.nil? && target_obj.respond_to?("replace_email_html")
          final_content = target_obj.replace_email_html(final_content, target, contact, permission_share)
        end
        
        final_content += "\n<p>\n--<br />\n"
        if user_display_short != user_email
          final_content += "#{user_display_short}<br />\n"
        end
        
        # Noticed some weird behavior in some responses from some people with the mailto
        # link being evaluated in their client as <javascript:_e(%7B%7D,'cvml','${EMAIL}');>
        # Since there's no need to have a mailto link anyway, remove it
        #final_content += "<a href=\"mailto:#{user_email}\">#{user_email}</a>"
        final_content += "#{user_email}"
        
        if identity.phone_numbers.count > 0
          final_content += identity.identity_phones.to_a.delete_if{|x| !x.worth_to_display?}.map{|p| "\n<br />#{p.context_info}: <a href=\"tel:#{p.number}\">#{p.number}</a>"}.join("")
        end
        final_content += "\n</p>\n\n"

        final_content += "<hr />\n"
        final_content += "<p>#{I18n.t("myplaceonline.unsubscribe.reply_hint", respond_to: user_display)}</p>\n"
        final_content += "<p>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.unsubscribe.link_unsubscribe_category", user: user_display, category: email_category), unsubscribe_category_link)}</p>\n"
        final_content += "<p>#{ActionController::Base.helpers.link_to(I18n.t("myplaceonline.unsubscribe.link_unsubscribe_all", user: user_display), unsubscribe_all_link)}</p>"
        
        final_content_plain = content_plain + "\n\n"

        if !personalization.nil? && !personalization.additional_text.blank?
          final_content_plain += personalization.additional_text + "\n\n"
        end
        
        if !target_obj.nil? && target_obj.respond_to?("add_email_plain")
          more_plain = target_obj.add_email_plain(target, contact, permission_share)
          if !more_plain.blank?
            final_content_plain += more_plain + "\n"
          end
        end
        
        if !target_obj.nil? && target_obj.respond_to?("replace_email_plain")
          more_plain = target_obj.replace_email_plain(final_content_plain, target, contact, permission_share)
          if !more_plain.blank?
            final_content_plain = more_plain + "\n"
          end
        end
        
        final_content_plain += "--\n"
        if user_display_short != user_email
          final_content_plain += "#{user_display_short}\n"
        end
        final_content_plain += "#{user_email}\n"
        if identity.phone_numbers.count > 0
          final_content_plain += identity.identity_phones.to_a.delete_if{|x| !x.worth_to_display?}.map{|p| "#{p.context_info}: #{p.number}\n"}.join("")
        end

        final_content_plain += "\n==\n\n"
        final_content_plain += "#{I18n.t("myplaceonline.unsubscribe.reply_hint", respond_to: user_display)}\n\n"
        final_content_plain += "#{I18n.t("myplaceonline.unsubscribe.link_unsubscribe_category", user: user_display, category: email_category)}: #{unsubscribe_category_link}\n\n"
        final_content_plain += "#{I18n.t("myplaceonline.unsubscribe.link_unsubscribe_all", user: user_display)}: #{unsubscribe_all_link}"
        
        if !contact.nil?
          final_content = final_content.gsub("%{name}", contact.contact_identity.display_short)
          final_content_plain = final_content_plain.gsub("%{name}", contact.contact_identity.display_short)
        end
        
        Rails.logger.info{"Sending email to #{target}"}

        Myp.send_email(
          to_hash.keys,
          subject,
          final_content.html_safe,
          cc_hash.keys,
          bcc_hash.keys,
          final_content_plain,
          identity.user.email,
          from_prefix: user_display_short
        )
        
        if !contact.nil?
          # If we sent an email, add a conversation
          Conversation.new(
            contact: contact,
            identity: identity,
            conversation: "[#{subject}](/emails/#{id})",
            conversation_date: User.current_user.date_now
          ).save!
        end
        
        sleep(1.0)
      end
    end
  end
  
  def process_group(to_hash, group)
    group.group_contacts.each do |group_contact|
      group_contact.contact.contact_identity.emails.each do |identity_email|
        to_hash[identity_email] = group_contact.contact
      end
    end
    group.group_references.each do |group_reference|
      process_group(to_hash, group_reference.group)
    end
  end

  def self.build(params = nil)
    result = self.dobuild(params)
    
    result.set_subject("")
    
    #result.use_bcc = true
    #result.copy_self = true
    
    if !params.nil? && !params["email_source_class"].blank?
      obj = Myp.find_existing_object(params["email_source_class"], params["email_source_id"].to_i)
      obj_display = obj.display
      result.set_subject(obj_display)
      result.body = obj.send(params["email_source_body_field"])
      result.set_body_if_blank(obj_display)
    end
    
    result
  end
  
  def set_subject(new_subject)
    if self.subject.blank?
      if ExecutionContext.count > 0 && !User.current_user.nil?
        self.subject = "#{User.current_user.current_identity.display_short} #{I18n.t("myplaceonline.emails.subject_shared")}: #{new_subject}"
      else
        self.subject = new_subject
      end
    else
      self.subject += new_subject
    end
  end
  
  def set_body_if_blank(new_body)
    if self.body.blank?
      self.body = new_body
    end
  end

  def send_immediately
    email_groups.count == 0 && email_contacts.count < 5
  end
  
  def process
    send_immediately_result = send_immediately
    Rails.logger.info{"Email processing async: #{!send_immediately_result}, email: #{self.inspect}"}
    if send_immediately_result
      ApplicationJob.perform_sync(AsyncEmailJob, self)
    else
      ApplicationJob.perform_async(AsyncEmailJob, self)
    end
  end
  
  def self.send_emails_to_contacts_and_groups_by_properties(subject, body_markdown, obj, contacts_property, groups_property)
    contacts = []
    groups = []
    
    if !contacts_property.nil?
      contacts = obj.send(contacts_property).map{|prop| prop.contact}
    end
    
    if !groups_property.nil?
      groups = obj.send(groups_property).map{|prop| prop.group}
    end
    
    total_count = 0
    if !contacts.nil?
      total_count += contacts.length
    end
    if !groups.nil?
      total_count += groups.length
    end
    
    if total_count > 0
      category = Myp.instance_to_category(obj).human_title

      self.send_emails_to_contacts_and_groups(category, subject, body_markdown, contacts, groups)
    end
  end
  
  def self.send_emails_to_contacts_and_groups(category, subject, body_markdown, contacts, groups)
    e = create_email_to_contacts_and_groups(category, subject, body_markdown, contacts, groups)
    e.process
  end
  
  def self.create_email_to_contacts_and_groups(category, subject, body_markdown, contacts, groups)
    if (!contacts.nil? && contacts.length > 0) || (!groups.nil? && groups.length > 0)
      e = Email.new
      e.email_category = category
      e.identity = User.current_user.current_identity
      contacts.each do |contact|
        ec = EmailContact.new
        ec.contact = contact
        ec.identity = e.identity
        e.email_contacts << ec
      end
      groups.each do |group|
        eg = EmailGroup.new
        eg.group = group
        eg.identity = e.identity
        e.email_groups << eg
      end
      e.subject = subject
      e.body = body_markdown
      e.save!
      e
    else
      nil
    end
  end

  def self.skip_check_attributes
    ["personalize", "draft", "use_bcc", "copy_self"]
  end
end
