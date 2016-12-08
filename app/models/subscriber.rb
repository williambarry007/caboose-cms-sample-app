class Subscriber < ActiveRecord::Base
  attr_accessible :site_id, :name, :email, :status
end

