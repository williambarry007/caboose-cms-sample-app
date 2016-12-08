class TwitterCache < ActiveRecord::Base
  attr_accessible :id, 
    :site_id,
    :body,
    :username,
    :tweet_id,
    :tweet_url,
    :created_at
end