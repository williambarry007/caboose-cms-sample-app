class Contact < ActiveRecord::Base
  attr_accessible :site_id, :sent_to, :name, :email, :subject, :message, :date_submitted, :contacted, :booked
end