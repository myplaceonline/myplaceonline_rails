class MypUtils
  @@default_host = "myplaceonline.com"
  
  if !ENV["DEFAULT_HOST"].blank?
    @@default_host = ENV["DEFAULT_HOST"]
  end
  
  def self.default_host
    @@default_host
  end
end
