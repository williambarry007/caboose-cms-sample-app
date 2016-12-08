class YoutubeCache < ActiveRecord::Base
  attr_accessible :id, 
    :site_id,
    :uploaded_at,
    :title,
    :description,
    :video_id,
    :view_count,
    :video_url,
    :username,
    :thumbnail_url
end