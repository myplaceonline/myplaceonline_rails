class ZipPlaylistJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    share = args[0]
    puts "Started " + share.inspect
  end
end
