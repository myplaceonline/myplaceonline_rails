class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Rails.logger.debug{"Started TestJob arg1=#{args[0]}"}
    Rails.logger.debug{"default_url_options = #{default_url_options.inspect}"}
    test = playlists_url
    Rails.logger.debug{"test = #{test.inspect}"}
    Rails.logger.debug{"Ended TestJob"}
  end
end
