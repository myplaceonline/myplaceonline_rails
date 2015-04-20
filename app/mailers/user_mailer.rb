class UserMailer < ActionMailer::Base
  default from: Myplaceonline::DEFAULT_SUPPORT_EMAIL
  
  def send_support_email(from, subject, content)
    @from = from
    @content = content
    mail(to: Myplaceonline::DEFAULT_SUPPORT_EMAIL, subject: subject)
  end
end
