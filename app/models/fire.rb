require 'httparty'
require 'uri'

class Fire < ActiveRecord::Base

  before_save :check_update_coords

  attr_accessible :id,
    :address,
    :latitude,
    :longitude,
    :cause,
    :name,
    :race,
    :gender,
    :age,
    :city,
    :county,
    :responding_department,
    :date

  def check_update_coords
    if self.address_changed?
      self.update_coords
    end
  end

  def update_coords
    if !self.address.blank?
      response = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?address=" + URI.encode(self.address + ", AL") + "&sensor=false")
      response = JSON.parse(response.body)
      if response && response.length > 0 && response['status'] != "ZERO_RESULTS"
        self.latitude = response['results'][0]['geometry']['location']['lat']
        self.longitude = response['results'][0]['geometry']['location']['lng']
      end
    end
  end

end