class TestApiController < ApplicationController
  include Rails.application.routes.url_helpers
  
  skip_authorization_check :only => [:hello_world]

  def hello_world
    render json: {
      message: "Hello World, #{User.current_user.display}"
    }
  end
end
