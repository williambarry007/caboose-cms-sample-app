class FacebookCache < ActiveRecord::Base
  attr_accessible :id, 
    :site_id,
    :page_name,
    :page_url,
    :profile_img,
    :page_id,
    :post_id,
    :post_url,
    :link,
    :story,
    :message,
    :picture,
    :description,
    :name,
    :post_type,
    :status_type,
    :date_created
end