class TrelloMember < ActiveRecord::Base
  has_many :trello_card_members
  has_many :trello_cards, :through => :trello_card_members
  attr_accessible :id, 
    :trello_id, 
    :avatar_hash,
    :full_name,
    :initials,
    :username
    
  def parse(h)
    self.trello_id   = h['id']
    self.avatar_hash = h['avatarHash']
    self.full_name   = h['fullName']
    self.initials    = h['initials']
    self.username    = h['username']        
  end
  
end
