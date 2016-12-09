class TestJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Chewy.strategy(:atomic) do
      Rails.logger.info{"Started TestJob arg1=#{args[0]}"}
      Rails.logger.info{"default_url_options = #{default_url_options.inspect}"}
      test = playlists_url
      Rails.logger.info{"test = #{test.inspect}"}
      Rails.logger.info{"Ended TestJob"}
    end
  end
end
