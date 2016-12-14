# Be sure to restart your server when you modify this file.
# http://api.rubyonrails.org/classes/ActionDispatch/Session/CookieStore.html
# http://www.rubydoc.info/github/rack/rack/master/Rack/Session/Abstract/Persisted
Rails.application.config.session_store(
  :cookie_store,
  key: "rails_session",
  expire_after: Myp::COOKIE_EXPIRATION
)
