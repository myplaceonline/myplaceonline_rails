class UserMailer < ActionMailer::Base
  default from: Myplaceonline::DEFAULT_SUPPORT_EMAIL
  
  def send_support_email(from, subject, content)
    @from = from
    @content = content
    mail(to: Myplaceonline::DEFAULT_SUPPORT_EMAIL, subject: subject)
  end
  
  def send_email(to, subject, content, bcc = nil)
    @content = content
    if bcc.nil?
      mail(to: to, subject: subject)
    else
      mail(to: to, subject: subject, bcc: bcc)
    end
  end
end
