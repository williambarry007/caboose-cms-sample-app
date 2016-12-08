require 'find'
require 'digest'
require 'date'

class SiteCreator
  
  def create_site(site_name, use_store = false, use_mls = false)
    puts "Creating the site..."
    
    slug = site_name.titleize.downcase.gsub(" ","").gsub("'","").gsub("-","")
    site = Caboose::Site.where(:name => slug).first
    site = Caboose::Site.create(:name => slug, :description => site_name, :use_fonts => true, :use_store => use_store) if site.nil?
            
    site.init_users_and_roles
    self.create_domains(site)
    self.create_pages(site, use_mls)    
    self.assign_block_types_to_site(site, use_mls)
    self.create_page_custom_fields(site)
    self.create_store_objects(site)
    self.create_smtp(site)
    self.create_fonts(site)             
  end
  
  #=============================================================================
  
  def create_domains(site)    
    domains = ["#{site.name}.caboosecms.com", "dev.#{site.name}.com:3000", "devadmin.#{site.name}.com:3000"]
    domains.each_with_index do |str, i|
      d = Caboose::Domain.where(:site_id => site.id, :domain => str, :primary => (i == 0)).first
      Caboose::Domain.create(:site_id => site.id, :domain => str, :primary => (i == 0)) if d.nil?
    end
  end
  
  #=============================================================================

  def create_pages(site, use_mls)
    
    # Create home page
    hp = Caboose::Page.where( :site_id => site.id, :parent_id => -1).first                         || Caboose::Page.create(:site_id => site.id, :parent_id => -1, :title => 'Home', :hide => false)
    hl = Caboose::BlockType.where( :parent_id => nil  , :name => "layout_#{site.name}_home").first || Caboose::BlockType.create(:parent_id => nil  , :name => "layout_#{site.name}_home", :description => "Home"   , :use_render_function => false, :use_render_function_for_layout => true , :allow_child_blocks => false, :field_type => "block", :block_type_category_id => 1)
    h  = Caboose::BlockType.where( :parent_id => hl.id, :name => "header"                  ).first || Caboose::BlockType.create(:parent_id => hl.id, :name => "header"                  , :description => "Header" , :use_render_function => false, :use_render_function_for_layout => false, :allow_child_blocks => false, :field_type => "block", :block_type_category_id => 2)
    c  = Caboose::BlockType.where( :parent_id => hl.id, :name => "content"                 ).first || Caboose::BlockType.create(:parent_id => hl.id, :name => "content"                 , :description => "Content", :use_render_function => false, :use_render_function_for_layout => false, :allow_child_blocks => true , :field_type => "block", :block_type_category_id => 2)
    f  = Caboose::BlockType.where( :parent_id => hl.id, :name => "footer"                  ).first || Caboose::BlockType.create(:parent_id => hl.id, :name => "footer"                  , :description => "Footer" , :use_render_function => false, :use_render_function_for_layout => false, :allow_child_blocks => false, :field_type => "block", :block_type_category_id => 2)                                                 
    b  = Caboose::Block.where(:page_id => hp.id, :parent_id => nil).first                          || Caboose::Block.create(:page_id => hp.id, :parent_id => nil, :name => "layout_#{site.name}_home", :block_type_id => hl.id, :sort_order => 0) if b.nil?
    
    # Create subpage
    sp = Caboose::Page.where( :site_id => site.id, :parent_id => hp.id, :title => "About").first       || Caboose::Page.create(:site_id => site.id, :parent_id => hp.id, :title => 'About', :slug => 'about', :uri => 'about', :hide => false) if sp.nil?        
    sl = Caboose::BlockType.where( :parent_id => nil  , :name => "layout_#{site.name}_subpage" ).first || Caboose::BlockType.create(:parent_id => nil  , :name => "layout_#{site.name}_subpage", :description => "Subpage", :use_render_function => false, :use_render_function_for_layout => true , :allow_child_blocks => false, :field_type => "block", :block_type_category_id => 1)            
    h  = Caboose::BlockType.where( :parent_id => sl.id, :name => "header"                      ).first || Caboose::BlockType.create(:parent_id => sl.id, :name => "header"                     , :description => "Header" , :use_render_function => false, :use_render_function_for_layout => false, :allow_child_blocks => false, :field_type => "block", :block_type_category_id => 2)
    c  = Caboose::BlockType.where( :parent_id => sl.id, :name => "content"                     ).first || Caboose::BlockType.create(:parent_id => sl.id, :name => "content"                    , :description => "Content", :use_render_function => false, :use_render_function_for_layout => false, :allow_child_blocks => true , :field_type => "block", :block_type_category_id => 2)
    f  = Caboose::BlockType.where( :parent_id => sl.id, :name => "footer"                      ).first || Caboose::BlockType.create(:parent_id => sl.id, :name => "footer"                     , :description => "Footer" , :use_render_function => false, :use_render_function_for_layout => false, :allow_child_blocks => false, :field_type => "block", :block_type_category_id => 2)        
    b  = Caboose::Block.where(:page_id => sp.id, :parent_id => nil).first                              || Caboose::Block.where(:page_id => sp.id, :parent_id => nil, :name => "layout_#{site.name}_subpage", :block_type_id => sl.id, :sort_order => 0)                        
    b.create_children
    b.child('content').update_field(:constrain, true)

    # Save the default layout
    site.default_layout_id = sl.id
    site.save
    
    # Make home page visible to everyone
    elo = Caboose::Role.where(:name => 'Everyone Logged Out', :site_id => site.id).first
    if elo_role      
      p = Caboose::PagePermission.where( :role_id => elo.id, :page_id => hp.id, :action => 'view').first || Caboose::PagePermission.create(:role_id => elo.id, :page_id => hp.id, :action => 'view')
      p = Caboose::PagePermission.where( :role_id => elo.id, :page_id => sp.id, :action => 'view').first || Caboose::PagePermission.create(:role_id => elo.id, :page_id => sp.id, :action => 'view')            
    end
    
    if site.use_store
      # Create products page
      pp = Caboose::Page.where(:site_id => site.id, :parent_id => hp.id, :title => 'Products').first || Caboose::Page.create(:site_id => site.id, :parent_id => hp.id, :title => 'Products', :slug => 'products', :uri => 'products', :hide => false)            
      b = Caboose::Block.where(:page_id => pp.id, :parent_id => nil).first || Caboose::Block.create(:page_id => pp.id, :parent_id => nil, :name => "layout_#{site.name}_subpage", :block_type_id => sl.id, :sort_order => 0)
      b.create_children
      c = b.child('content')
      c.update_field(:constrain, true)      
      
      # Create products block instance for products page
      b = Caboose::Block.where( :page_id => pp.id, :block_type_id => 657).first
      b = Caboose::Block.create(:page_id => pp.id, :block_type_id => 657, :parent_id => c.id, :name => nil, :sort_order => 0) if b.nil?
    end
    
    if use_mls
      # Create residential page and rets layout block       
      rp = Caboose::Page.where( :site_id => site.id, :parent_id => hp.id, :title => 'Residential').first 
      rp = Caboose::Page.create(:site_id => site.id, :parent_id => hp.id, :title => 'Residential', :slug => 'residential', :uri => 'residential', :hide => false) if rp.nil?            
      b = Caboose::Block.where( :page_id => rp.id, :parent_id => nil).first
      b = Caboose::Block.create(:page_id => rp.id, :parent_id => nil, :name => "layout_rets", :block_type_id => 1905, :sort_order => 0) if b.nil?                                         
    end
  end
      
  #=============================================================================
  
  def assign_block_types_to_site(site, use_mls)
              
    # Add basic block types to site's block type memberships
    default_block_types = [405,484,1,21,391,398,309,343,366,450,528,356,422,715,788,806,807,822,835,859,1049,1201,1306,815,1326,1368,1745,2045,2054,2164,2167,2342,1575]
    default_block_types = default_block_types + [816, 657] if site.store
    default_block_types = default_block_types + [1963, 1905, 2108, 2124, 2280] if use_mls      
    default_block_types.each do |bt_id|
      btsm = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => bt_id).first
      btsm = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => bt_id) if btsm.nil?      
    end

    hl = Caboose::BlockType.where(:parent_id => nil, :name => "layout_#{site.name}_home"   ).first
    sl = Caboose::BlockType.where(:parent_id => nil, :name => "layout_#{site.name}_subpage").first
    
    # Add home page layout to site's block type memberships    
    btsm = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => hl.id).first
    btsm = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => hl.id) if btsm.nil?
    
    # Add subpage layout to site's block type memberships
    btsm = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => sl.id).first
    btsm = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => sl.id) if btsm.nil?
    
  end
  
  #=============================================================================

  def create_page_custom_fields(site)    
    pcf = Caboose::PageCustomField.where(:site_id => site.id, :key => "vertical_padding").first
    if pcf.nil?
      pcf = Caboose::PageCustomField.create(
        :site_id       => site.id,
        :key           => "vertical_padding",
        :name          => "Vertical Padding",
        :field_type    => "text",
        :default_value => "20px",
        :sort_order    => 0
      )
    end
  end
  
  #=============================================================================
  
  def create_store_objects(site)
    return if !site.use_store            
    cat = Caboose::Category.where( :site_id => site.id, :parent_id => nil, :slug => 'products').first
    cat = Caboose::Category.create(:site_id => site.id, :parent_id => nil, :slug => 'products', :url => '/products', :name => 'All Products', :status => 'Active') if cat.nil?     
    v = Caboose::Vendor.where( :site_id => site.id, :name => site.description).first
    v = Caboose::Vendor.create(:site_id => site.id, :name => site.description, :status => 'Active') if v.nil?            
    sc = Caboose::StoreConfig.where( :site_id => site.id).first
    sc = Caboose::StoreConfig.create(:site_id => site.id, :pp_name => 'stripe') if sc.nil?
  end
  
  #=============================================================================

  def create_smtp(site)
    smtp = Caboose::SmtpConfig.where(:site_id => site.id).first || Caboose::SmtpConfig.create(          
      :site_id              => site.id,
      :address              => "email-smtp.us-east-1.amazonaws.com",
      :port                 => "587",
      :domain               => "caboosecms.com",
      :user_name            => "AKIAILLCSBRZHLLN562Q",
      :password             => "Aro/z7tOf2atTa/Y4dhEjH1SQHWc7rF/ybzvEZ7wmXtl",
      :authentication       => "plain",
      :enable_starttls_auto => true,
      :from_address         => "noreply@caboosecms.com"
    )
  end
  
  #=============================================================================
  
  def create_fonts(site)
    Caboose::Font.where(:site_id => site.id, :name => 'body-font'            ).exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font'            , :family => 'Lato', :variant => '300'       , :url => 'http://fonts.gstatic.com/s/lato/v11/Ja02qOppOVq9jeRjWekbHg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'button-font'          ).exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'button-font'          , :family => 'Lato', :variant => '300'       , :url => 'http://fonts.gstatic.com/s/lato/v11/Ja02qOppOVq9jeRjWekbHg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'body-font-bold'       ).exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font-bold'       , :family => 'Lato', :variant => '700'       , :url => 'http://fonts.gstatic.com/s/lato/v11/iX_QxBBZLhNj5JHlTzHQzg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'body-font-italic'     ).exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font-italic'     , :family => 'Lato', :variant => '300italic' , :url => 'http://fonts.gstatic.com/s/lato/v11/dVebFcn7EV7wAKwgYestUg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'body-font-bold-italic').exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font-bold-italic', :family => 'Lato', :variant => '700italic' , :url => 'http://fonts.gstatic.com/s/lato/v11/WFcZakHrrCKeUJxHA4T_gw.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'heading-font'         ).exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'heading-font'         , :family => 'Lato', :variant => 'regular'   , :url => 'http://fonts.gstatic.com/s/lato/v11/h7rISIcQapZBpei-sXwIwg.ttf')
  end
  
  #=============================================================================
    
  # Copies all the files in the sample directory to the host application
  def init_skeleton_files(site, use_rets)    
    puts "----------------------------------------------------------------------"    
    puts "Creating skeleton files for #{site.name}"
     
    if File.directory?("sites/#{site.name}") # Site already exists
      puts "The files for #{site.name} already exist."
      return
    end
    
    # Create site folders
    `mkdir sites/#{site.name}`
    `mkdir sites/#{site.name}/blocks`
    `mkdir sites/#{site.name}/css`
    `mkdir sites/#{site.name}/css/blocks`
    `mkdir sites/#{site.name}/css/modules`
    `mkdir sites/#{site.name}/css/pages`
    `mkdir sites/#{site.name}/fonts`
    `mkdir sites/#{site.name}/images`
    `mkdir sites/#{site.name}/images/icons`
    `mkdir sites/#{site.name}/js`

    puts "Created site folder 'sites/#{site.name}'"
    puts "Adding bootstrap files to site folder..."
    
    skeleton_root = "bootstrap"    
    Find.find(skeleton_root).each do |file|    
      next if File.directory?(file)
      next if !site.user_store && (file.include?('product') || file.include?('search_results'))
      next if !use_mls && file.include?('rets')
      next if file.include?(".DS_Store")
      file2 = file.gsub(skeleton_root, '').gsub("sitename", site.name)
      file2 = File.join(File.expand_path("sites/#{site.name}"), file2)
      FileUtils.cp(file, file2)
      
      #Replace any variables
      if File.extname(file2) == ".erb" || File.extname(file2) == ".css" || File.extname(file2) == ".js" || File.extname(file2) == ".scss"
        f = File.open(file2, 'rb')
        str = f.read
        f.close
        if !site.use_store
          str.gsub!('@import "|SITE_SLUG|/css/pages/products";','')
          str.gsub!('@import "|SITE_SLUG|/css/pages/product_details";','')
          str.gsub!('@import "|SITE_SLUG|/css/pages/product_index";','')
          str.gsub!('//= require |SITE_SLUG|/js/products','')
        end
        if !use_mls
          str.gsub!('@import "|SITE_SLUG|/css/pages/rets";','')
          str.gsub!('@import "|SITE_SLUG|/css/pages/rets_residential_details";','')
          str.gsub!('@import "|SITE_SLUG|/css/pages/rets_residential_index";','')
          str.gsub!("//= require |SITE_SLUG|/js/functions_rets","")
          str.gsub!("//= require photoswipe","")
          str.gsub!("//= require photoswipe_ui","")
          str.gsub!(" *= require photoswipe","")
          str.gsub!(" *= require photoswipe_skin","")
          str.gsub!("_skin","")
          str.gsub!("_ui","")
        end
        str.gsub!("|SITE_SLUG|", site.name)
        str.gsub!("|SITE_NAME|", site.description)
        str.gsub!("|HOME_PAGE_ID|", Caboose::Page.index_page(site.id).id.to_s)
        File.open(file2, 'w') { |f| f.write(str) }
      end  
    end  
  end
  
end
