class VimeoCache < ActiveRecord::Base
  attr_accessible :id, 
    :site_id,
    :uploaded_at,
    :title,
    :description,
    :video_id,
    :video_url,
    :username,
    :thumbnail_url,
    :tags,
   	:view_count,
   	:like_count 
end