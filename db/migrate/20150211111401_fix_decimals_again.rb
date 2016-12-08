class FixDecimalsAgain < ActiveRecord::Migration
  def self.up                 
    change_column :store_gift_cards         , :total           , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_gift_cards         , :balance         , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_gift_cards         , :min_order_total , :decimal, :precision => 8, :scale => 2, :default => nil              
    change_column :store_line_items         , :price           , :decimal, :precision => 8, :scale => 2, :default => nil      
    change_column :store_order_transactions , :amount          , :decimal, :precision => 8, :scale => 2, :default => nil              
    change_column :store_order_packages     , :total           , :decimal, :precision => 8, :scale => 2, :default => nil     
    change_column :store_orders             , :subtotal        , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_orders             , :tax             , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_orders             , :shipping        , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_orders             , :handling        , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_orders             , :custom_discount , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_orders             , :discount        , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_orders             , :total           , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_orders             , :auth_amount     , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_variants           , :price           , :decimal, :precision => 8, :scale => 2, :default => nil
    change_column :store_variants           , :sale_price      , :decimal, :precision => 8, :scale => 2, :default => nil      
  end
    
  def self.down
    
  end
end
