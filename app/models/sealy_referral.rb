class SealyReferral < ActiveRecord::Base
  attr_accessible :site_name, :your_name, :your_email, :friend_1_email, :friend_2_email, :friend_3_email, :friend_4_email, :date_submitted
end