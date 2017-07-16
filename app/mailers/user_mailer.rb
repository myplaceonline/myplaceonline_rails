class UserMailer < ActionMailer::Base
  def send_support_email(from, subject, content, content_plain = nil)
    @time = Time.now.in_time_zone(Rails.application.config.time_zone).to_s(:full)
    @from = from
    @content = content
    if !content_plain.nil?
      @content_plain = content_plain
    else
      @content_plain = @content
    end
    support = Myp.create_email
    mail(from: support, to: support, subject: subject, reply_to: @from)
  end
  
  def send_email(to, subject, content, cc = nil, bcc = nil, content_plain = nil, reply_to = nil, from_prefix: nil)
    @content = content
    if !content_plain.nil?
      @content_plain = content_plain
    else
      @content_plain = @content
    end
    from = Myp.create_email(display_prefix: from_prefix, display_prefix_suffix: I18n.t("myplaceonline.emails.from_prefix_context"))
    mail(from: from, to: to, subject: subject, cc: cc, bcc: bcc, reply_to: reply_to)
  end
end
