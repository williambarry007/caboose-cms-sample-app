class InstagramCache < ActiveRecord::Base
  attr_accessible :id, 
    :site_id,
    :image_url,
    :link_url,
    :instagram_id,
    :username, 
    :caption,
    :location,
    :date_created
end