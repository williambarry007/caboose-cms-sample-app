class FixOrders < ActiveRecord::Migration
  def self.up      
    change_column :store_orders, :subtotal, :decimal, :precision => 8, :scale => 2, :default => 0.00
  end
    
  def self.down
    
  end
end
