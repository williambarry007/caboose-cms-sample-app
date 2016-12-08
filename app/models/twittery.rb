include Twitter::Autolink

class Twittery
  def self.latest_tweets(username, limit)
    begin
      client = Twitter::REST::Client.new do |config|
        config.consumer_key        = "U6tr21tvhez6tnOtdSP0nDmo1"
        config.consumer_secret     = "sYmwRSvE6REd8NvAXQY9MFsTfvnZPuk60ja5gTS0g2ttzWLBxb"
        config.access_token        = "44284266-t8X5HqDPL3MAdh29bFuflf2k2iLdqOUUC8iAGKRdv"
        config.access_token_secret = "5iv4jVaK0oTnclVKt90PrV8H1d8XRnRbQwOJ8UT2hntdh"
      end 
      return client.user_timeline(username).take(limit)
    rescue
      return nil
    end
  end
end