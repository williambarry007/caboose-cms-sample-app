class MapStyle < ActiveRecord::Base

	self.table_name = 'map_styles'

  attr_accessible :id,
  	:alt_id,
    :name,
    :description,
    :code

end