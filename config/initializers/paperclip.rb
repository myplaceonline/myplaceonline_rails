require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end

worrisome_adapters = [Paperclip::UriAdapter, Paperclip::HttpUrlProxyAdapter, Paperclip::DataUriAdapter]

Paperclip.io_adapters
         .registered_handlers
         .delete_if do |_block, handler_class|
           worrisome_adapters.include?(handler_class)
         end
