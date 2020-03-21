if !ENV['YELP_CONSUMER_KEY'].nil?
  Yelp.client.configure do |config|
    config.consumer_key = ENV['YELP_CONSUMER_KEY']
    config.consumer_secret = ENV['YELP_CONSUMER_SECRET']
    config.token = ENV['YELP_TOKEN']
    config.token_secret = ENV['YELP_TOKEN_SECRET']
  end
else
  #puts "Warning: Yelp API keys not configured: YELP_CONSUMER_KEY=\"\" YELP_CONSUMER_SECRET=\"\" YELP_TOKEN=\"\" YELP_TOKEN_SECRET=\"\""
end
