# https://github.com/hassox/warden/wiki/Callbacks
Warden::Manager.before_logout do |user, auth, opts|
  # Handled in Users::SessionsController
  #Rails.logger.debug{"Warden before_logout user: #{user}, auth: #{auth}, opts: #{opts}"}
end
