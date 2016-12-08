class TrelloList < ActiveRecord::Base
  has_many :trello_cards
  attr_accessible :id, :trello_id, :name
  
  def parse(h)
    self.name = h['name']
  end
end