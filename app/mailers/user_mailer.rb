class UserMailer < ActionMailer::Base
  default from: Myplaceonline::DEFAULT_SUPPORT_EMAIL
  
  def send_support_email(from, subject, content)
    @from = from
    @content = content
    mail(to: Myplaceonline::DEFAULT_SUPPORT_EMAIL, subject: subject)
  end
  
  def send_email(to, subject, content, cc = nil, bcc = nil)
    @content = content
    mail(to: to, subject: subject, cc: cc, bcc: bcc)
  end
end
