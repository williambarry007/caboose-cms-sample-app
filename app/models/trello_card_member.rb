class TrelloCardMember < ActiveRecord::Base

  belongs_to :trello_card
  belongs_to :trello_member  
  attr_accessible :id, :trello_card_id, :trello_member_id
  
end
