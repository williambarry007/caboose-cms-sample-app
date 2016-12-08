class StripeDonation < ActiveRecord::Base
  attr_accessible :site_id, :email_address, :date_submitted, :name, :amount
end