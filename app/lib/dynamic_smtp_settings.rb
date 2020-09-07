class DynamicSmtpSettings
  def initialize(params = {})
    @params = params.merge({
      address: ENV["SMTP_HOST"],
      port: 587,
      user_name: ENV["SMTP_USER"],
      password: ENV["SMTP_PASSWORD"],
      authentication: :login,
      enable_starttls_auto: true,
    })
  end
  
  def method_missing(name, *args, &block)
    @params[:domain] = MyplaceonlineExecutionContext.host
    @params.send(name, *args, &block)
  end
end
