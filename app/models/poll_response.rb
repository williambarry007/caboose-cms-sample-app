class PollResponse < ActiveRecord::Base
  attr_accessible :site_id, :poll_block_id, :poll_answer_block_id, :date_submitted, :user_id, :ip_address
end