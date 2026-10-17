Rails.logger.debug{"Loading paperclip.rb"}

require 'paperclip/media_type_spoof_detector'
require 'paperclip_database'

module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

Paperclip::Attachment.default_options[:validate_media_type] = false

