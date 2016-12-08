class SealyLead < ActiveRecord::Base
  attr_accessible :site_name, :first_name, :last_name, :phone, :email, :date_submitted
end