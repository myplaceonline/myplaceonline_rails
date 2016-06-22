class UserMailer < ActionMailer::Base
  default from: Myplaceonline::DEFAULT_SUPPORT_EMAIL
  
  def send_support_email(from, subject, content, content_plain = nil)
    @from = from
    @content = content
    if !content_plain.nil?
      @content_plain = content_plain
    else
      @content_plain = @content
    end
    mail(to: Myplaceonline::DEFAULT_SUPPORT_EMAIL, subject: subject)
  end
  
  def send_email(to, subject, content, cc = nil, bcc = nil, content_plain = nil, reply_to = nil, from_prefix: nil)
    @content = content
    if !content_plain.nil?
      @content_plain = content_plain
    else
      @content_plain = @content
    end
    from = Myplaceonline::DEFAULT_SUPPORT_EMAIL
    if !from_prefix.blank?
      from = clean_from_prefix(from_prefix) + " " + I18n.t("myplaceonline.emails.from_prefix_context") + " " + from
    end
    mail(from: from, to: to, subject: subject, cc: cc, bcc: bcc, reply_to: reply_to)
  end
  
  private
    def clean_from_prefix(from_prefix)
      from_prefix.gsub(/[<@>]/, "")
    end
end
