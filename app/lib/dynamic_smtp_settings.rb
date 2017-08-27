class DynamicSmtpSettings
  def initialize(params = {})
    @params = params.merge({
      :address              => "smtp.sendgrid.net",
      :port                 => 587,
      :user_name            => ENV["SMTP_USER"],
      :password             => ENV["SMTP_PASSWORD"],
      :authentication       => :login,
      :enable_starttls_auto => true
    })
  end
  
  def method_missing(name, *args, &block)
    if name.to_s == "[]" && args && args.length > 0 && args[0] == :domain
      MyplaceonlineExecutionContext.host
    else
      @params.send(name, *args, &block)
    end
  end
end
