require 'mysql2'
require 'httparty'
require 'json'
require 'uri'

class LockerroomImporter

  def initialize
    @client = Mysql2::Client.new(
      #:host => "old.repconnex.com",
      #:database => "repconnex",
      #:username => "nineadmin", 
      #:password => "Mohawk77"
      :host => "localhost",
      :database => "lockerroom",
      :username => "root", 
      :password => ""
    )        
  end
  
  def select_all(query)
    return @client.query(query)
  end
  
  def select_row(query)
    rows = @client.query(query)
    return nil if rows.nil? || rows.count == 0
    return rows.first 
  end
  
  #=============================================================================
  
  def import    
    #self.import_categories
    #self.import_vendors
    self.import_products
  end
  
  #=============================================================================
  
  def import_categories
    self.log("Importing categories...")
    @cat_ids = []
    top_cat = Caboose::Category.find(10)
    import_categories_helper(0, top_cat)
  end
  
  def import_categories_helper(parent_alternate_id, parent_cat)
    #return if @cat_ids.include?(parent_alternate_id) # Infinite loop
    rows = self.select_all("select * from categories where parent_category_id = #{parent_alternate_id} and is_deleted = 'N'")
    rows.each do |row|
      self.log(" - #{row['category']}...")
      cat = Caboose::Category.where(:alternate_id => row['category_id'].to_s).first
      cat = Caboose::Category.new(:alternate_id => row['category_id'].to_s) if cat.nil?
      cat.site_id = 28
      cat.parent_id = parent_cat.id
      cat.name = row['category']
      cat.slug = cat.generate_slug
      cat.url = "#{parent_cat.url}/#{cat.slug}"
      cat.status = row['is_active'] == 'Y' ? Caboose::Category::STATUS_ACTIVE : Caboose::Category::STATUS_INACTIVE
      cat.image = URI.parse("http://www.locker-room.biz/#{row['medium_path']}")
      cat.save
      @cat_ids << row['category_id']
        
      self.import_categories_helper(row['category_id'], cat)
    end
  end
  
  #=============================================================================
  
  def import_vendors
    self.log("Importing vendors...")    
    rows = self.select_all("select * from brands order by brand_name")
    rows.each do |row|  
      self.log("- #{row['brand_code']}...")
      v = Caboose::Vendor.where(:alternate_id => row['brand_id'].to_s).first
      v = Caboose::Vendor.new(:alternate_id => row['brand_id'].to_s) if v.nil?
      
      v.site_id = 28
      v.name = row['brand_name']
      v.image = URI.parse("http://www.locker-room.biz/#{row['logo_path']}")
      v.save
    end
  end
  
  #=============================================================================
  
  def import_products
    self.log("Importing products...")
    rows = self.select_all("select * from products where is_deleted = 'N'")
    rows.each do |row|            
      self.import_product(row)                       
    end
  end    
  
  def import_product(product_row)
    self.log("Importing product #{product_row['product_id']}...")
    p = Caboose::Product.where(:alternate_id => product_row['product_id'].to_s).first
    p = Caboose::Product.new if p.nil?
    
    p.site_id       = 28
    p.alternate_id  = product_row['product_id']
    p.title         = product_row['product_name']
    p.caption       = product_row['short_description']
    p.description   = product_row['long_description']
    p.handle        = product_row['product_code']
    p.vendor_id     = product_row['brand_id']    
    p.status        = 'Active'        
    p.featured      = product_row['is_featured'] == 'Y'
    p.save
    
    # Find the vendor
    self.log("- Finding vendor...")
    v = Caboose::Vendor.where(:alternate_id => product_row['brand_id'].to_s).first
    p.vendor_id = v.id if v
    
    self.log("- Getting attributes...")
    option_rows = {}
    attribute_rows = self.select_all("select * from attributes where product_id = '#{product_row['product_id']}' order by attribute")
    if attribute_rows.count > 3
      self.log("ERROR: Too many attributes for product #{product_row['product_id']}.")
      return
    end
            
    if attribute_rows                  
      attribute_rows.each_with_index do |attribute_row, i|
        p.option1 = attribute_row['attribute'] if i == 0 
        p.option2 = attribute_row['attribute'] if i == 1 
        p.option3 = attribute_row['attribute'] if i == 2       
        option_rows[i] = self.select_all("select * from attribute_options where attribute_id = '#{attribute_row['attribute_id']}' order by option_id")        
      end
      p.save
    end
            
    # Create the variants
    self.log("- Creating variants...")
    if p.option1 && p.option2 && p.option3 && option_rows[0] && option_rows[1] && option_rows[2]
      option_rows[0].each do |row1|
        option_rows[1].each do |row2|
          option_rows[2].each do |row3|
            h = { :product_id => p.id, :option1 => row1['attribute_option'], :option2 => row2['attribute_option'], :option3 => row3['attribute_option'] }
            v = Caboose::Variant.where(h).first                                        
            v = Caboose::Variant.new(h) if v.nil?                        
            v.price  = product_row['product_price']
            v.status = 'Active'
            v.weight = product_row['product_weight'].to_f
            v.quantity_in_stock = 100
            v.save
          end
        end
      end
    elsif p.option1 && p.option2 && option_rows[0] && option_rows[1]
      option_rows[0].each do |row1|
        option_rows[1].each do |row2|
          h = { :product_id => p.id, :option1 => row1['attribute_option'], :option2 => row2['attribute_option'] }            
          v = Caboose::Variant.where(h).first                                        
          v = Caboose::Variant.new(h) if v.nil?                        
          v.price  = product_row['product_price']
          v.status = 'Active'
          v.weight = product_row['product_weight'].to_f
          v.quantity_in_stock = 100
          v.save          
        end
      end    
    elsif p.option1 && option_rows[0]
      option_rows[0].each do |row1|
        h = { :product_id => p.id, :option1 => row1['attribute_option'] }        
        v = Caboose::Variant.where(h).first                                        
        v = Caboose::Variant.new(h) if v.nil?                        
        v.price  = product_row['product_price']
        v.status = 'Active'
        v.weight = product_row['product_weight'].to_f
        v.quantity_in_stock = 100
        v.save        
      end
    else      
      h = { :product_id => p.id }        
      v = Caboose::Variant.where(h).first                                        
      v = Caboose::Variant.new(h) if v.nil?                        
      v.price  = product_row['product_price']
      v.status = 'Active'
      v.weight = product_row['product_weight'].to_f
      v.quantity_in_stock = 100
      v.save
    end
    
    # Assign the product to categories
    #self.log("- Assigning the product to categories...")
    #cat_rows = self.select_all("select * from category_products where product_id = '#{product_row['product_id']}'")
    #cat_rows.each do |cat_row|
    #  cat = Caboose::Category.where(:alternate_id => cat_row['category_id'].to_s).first
    #  next if cat.nil?
    #  cm = Caboose::CategoryMembership.where(:product_id => p.id, :category_id => cat.id).first
    #  Caboose::CategoryMembership.create(:product_id => p.id, :category_id => cat.id) if cm.nil?
    #end
    
    ## Get the product images
    #self.log("- Getting images...")
    #image_rows = self.select_all("select * from product_images where product_id = '#{product_row['product_id']}' order by image_id")
    #image_rows.each do |image_row|
    #  self.log("- - #{image_row['large_path']}")
    #  img = Caboose::ProductImage.where(:alternate_id => image_row['image_id'].to_s).first
    #  exists = (img ? true : false)      
    #  img = Caboose::ProductImage.new if img.nil?      
    #  img.product_id   = p.id
    #  img.alternate_id = image_row['image_id']
    #  img.title        = image_row['image_caption']
    #  img.image        = URI.parse("http://www.locker-room.biz/#{image_row['large_path']}") if !exists
    #  img.save           
    #end
    
  end      
  
  def log(msg)
    puts msg  
  end
  
end
