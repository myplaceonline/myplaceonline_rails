# The Rails session cookie is separate from the Devise rememberable cookie. If "Remember Me" is not checked, then the
# Devise cookie isn't created, and the user ID is in the Rails session cookie. If "Remember Me" is checked, then Devise
# creates its cookie with the expiration specified in the devise.rb initializer. We don't set expire_after on the Rails
# cookie because then the user will be constantly logged in no matter whether "Remember Me" was checked or not.
# Effectively, the Rails session should only be used for data stored for the duration of the browser session. For
# anything else, create a separate cookie and hook into after_remembered.

# Be sure to restart your server when you modify this file.
# http://api.rubyonrails.org/classes/ActionDispatch/Session/CookieStore.html
# http://api.rubyonrails.org/classes/ActionDispatch/Cookies.html
# http://www.rubydoc.info/github/rack/rack/master/Rack/Session/Abstract/Persisted
Rails.application.config.session_store(
  :cookie_store
)

Rails.application.config.session_options = DynamicCookieOptions.new(
  {
    key: "rails_session",
    # expire_after: Myp::COOKIE_EXPIRATION,
  }
)
