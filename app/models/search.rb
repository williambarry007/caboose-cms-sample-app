class Search < ActiveRecord::Base
  attr_accessible :site_id, :date_searched, :query, :results
end