class TrelloCard < ActiveRecord::Base
  
  belongs_to :trello_list
  has_many :trello_card_members
  has_many :trello_members, :through => :trello_card_members  
  attr_accessible :id, 
    :trello_id, 
    :trello_list_id, 
    :name, 
    :due
  
  def parse(h)    
    self.name = h['name']
    self.pos  = h['pos'].to_i
    self.due  = h['due']
    
    list = TrelloList.where(:trello_id => h['idList']).first
    self.trello_list_id = list ? list.id : nil
  end
    
end