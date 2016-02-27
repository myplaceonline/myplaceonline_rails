class UserMailer < ActionMailer::Base
  default from: Myplaceonline::DEFAULT_SUPPORT_EMAIL
  
  def send_support_email(from, subject, content)
    @from = from
    @content = content
    mail(to: Myplaceonline::DEFAULT_SUPPORT_EMAIL, subject: subject)
  end
  
  def send_email(to, subject, content, cc = nil, bcc = nil, content_plain = nil, reply_to = nil)
    @content = content
    if !content_plain.nil?
      @content_plain = content_plain
    else
      @content_plain = @content
    end
    mail(to: to, subject: subject, cc: cc, bcc: bcc, reply_to: reply_to)
  end
end
