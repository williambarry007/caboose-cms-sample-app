require 'find'
require 'digest'
require 'date'

class SiteHelper
  
  def initialize(site_name, use_store = "n", use_mls = "n")
    @site_name = site_name.titleize
    @site_name_slug = @site_name.downcase.gsub(" ","").gsub("'","").gsub("-","")  
    @store = use_store.downcase == "y" ? true : false
    @mls   = use_mls.downcase   == "y" ? true : false
  end

  def password_generator(site_name)
    password = "password123*"
    numb = rand(100...999)
    if !site_name.blank? 
        pw = site_name.downcase.gsub("o","0").gsub("s","$").gsub("-","_").gsub("e","3").gsub("i","!").titleize.gsub(" ","_") + "_" + numb.to_s + "*"
    end
  end

  def create_site_blocks

    # Create Caboose site
    old_site = Caboose::Site.where(:name => @site_name_slug).last
    if old_site
        puts "That site already exists"
        return
    else
        site = Caboose::Site.new
        site.name = @site_name_slug
        site.description = @site_name
        site.use_fonts = true
        if @store
            site.use_store = true
            site.allow_self_registration = true
        end
        site.save
        site.init_users_and_roles
    end

    # Create home page
    old_home_page = Caboose::Page.where(:title => "Home", :site_id => site.id).last
    home_page = old_home_page ? old_home_page : Caboose::Page.new
    home_page.parent_id = -1
    home_page.title = "Home"
    home_page.hide = false
    home_page.site_id = site.id
    home_page.save

    # puts "\n"
    # puts "----------------------------------"
    # puts "HOME PAGE ID: " + home_page.id.to_s
    # puts "----------------------------------"

    # Create subpage
    old_sub_page = Caboose::Page.where(:title => "About", :site_id => site.id).last
    sub_page = old_sub_page ? old_sub_page : Caboose::Page.new
    sub_page.parent_id = home_page.id
    sub_page.title = "About"
    sub_page.slug = "about"
    sub_page.uri = "about"
    sub_page.hide = false
    sub_page.site_id = site.id
    sub_page.save

    # Create production domain
    old_domain = Caboose::Domain.where(:site_id => site.id, :domain => "#{@site_name_slug}.caboosecms.com").last
    domain = old_domain ? old_domain : Caboose::Domain.new
    domain.site_id = site.id
    domain.domain = "#{@site_name_slug}.caboosecms.com"
    domain.primary = true
    domain.save

    # Create development domain
    old_dev_domain = Caboose::Domain.where(:site_id => site.id, :domain => "dev.#{@site_name_slug}.com:3000").last
    dev_domain = old_dev_domain ? old_dev_domain : Caboose::Domain.new
    dev_domain.site_id = site.id
    dev_domain.domain = "dev.#{@site_name_slug}.com:3000"
    dev_domain.primary = false
    dev_domain.save

  #  if @store
        # Create admin development domain
        old_dev_admin_domain = Caboose::Domain.where(:site_id => site.id, :domain => "devadmin.#{@site_name_slug}.com:3000").last
        dev_admin_domain = old_dev_admin_domain ? old_dev_admin_domain : Caboose::Domain.new
        dev_admin_domain.site_id = site.id
        dev_admin_domain.domain = "devadmin.#{@site_name_slug}.com:3000"
        dev_admin_domain.primary = false
        dev_admin_domain.save
  #  end

    # Create home page layout block type
    old_home_layout = Caboose::BlockType.where("parent_id IS NULL").where(:name => "layout_#{@site_name_slug}_home").last
    home_layout = old_home_layout ? old_home_layout : Caboose::BlockType.new
    home_layout.name = "layout_#{@site_name_slug}_home"
    home_layout.parent_id = nil
    home_layout.description = "Home"
    home_layout.use_render_function = false
    home_layout.use_render_function_for_layout = true
    home_layout.allow_child_blocks = false
    home_layout.field_type = "block"
    home_layout.block_type_category_id = 1
    home_layout.save

    # Create home page header block type
    old_home_layout_header = Caboose::BlockType.where(:parent_id => home_layout.id).where(:name => "header").last
    home_layout_header = old_home_layout_header ? old_home_layout_header : Caboose::BlockType.new
    home_layout_header.name = "header"
    home_layout_header.parent_id = home_layout.id
    home_layout_header.description = "Header"
    home_layout_header.use_render_function = false
    home_layout_header.use_render_function_for_layout = false
    home_layout_header.allow_child_blocks = false
    home_layout_header.field_type = "block"
    home_layout_header.block_type_category_id = 2
    home_layout_header.save

    # Create home page content block type
    old_home_layout_content = Caboose::BlockType.where(:parent_id => home_layout.id).where(:name => "content").last
    home_layout_content = old_home_layout_content ? old_home_layout_content : Caboose::BlockType.new
    home_layout_content.name = "content"
    home_layout_content.parent_id = home_layout.id
    home_layout_content.description = "Content"
    home_layout_content.use_render_function = false
    home_layout_content.use_render_function_for_layout = false
    home_layout_content.allow_child_blocks = true
    home_layout_content.field_type = "block"
    home_layout_content.block_type_category_id = 2
    home_layout_content.save

    # Create home page footer block type
    old_home_layout_footer = Caboose::BlockType.where(:parent_id => home_layout.id).where(:name => "footer").last
    home_layout_footer = old_home_layout_footer ? old_home_layout_footer : Caboose::BlockType.new
    home_layout_footer.name = "footer"
    home_layout_footer.parent_id = home_layout.id
    home_layout_footer.description = "Footer"
    home_layout_footer.use_render_function = false
    home_layout_footer.use_render_function_for_layout = false
    home_layout_footer.allow_child_blocks = false
    home_layout_footer.field_type = "block"
    home_layout_footer.block_type_category_id = 2
    home_layout_footer.save

    # Create subpage layout block type
    old_subpage_layout = Caboose::BlockType.where("parent_id IS NULL").where(:name => "layout_#{@site_name_slug}_subpage").last
    subpage_layout = old_subpage_layout ? old_subpage_layout : Caboose::BlockType.new
    subpage_layout.name = "layout_#{@site_name_slug}_subpage"
    subpage_layout.parent_id = nil
    subpage_layout.description = "Subpage"
    subpage_layout.use_render_function = false
    subpage_layout.use_render_function_for_layout = true
    subpage_layout.allow_child_blocks = false
    subpage_layout.field_type = "block"
    subpage_layout.block_type_category_id = 1
    subpage_layout.save
    site.default_layout_id = subpage_layout.id
    site.save

    # Create subpage header block type
    old_subpage_layout_header = Caboose::BlockType.where(:parent_id => subpage_layout.id).where(:name => "header").last
    subpage_layout_header = old_subpage_layout_header ? old_subpage_layout_header : Caboose::BlockType.new
    subpage_layout_header.name = "header"
    subpage_layout_header.parent_id = subpage_layout.id
    subpage_layout_header.description = "Header"
    subpage_layout_header.use_render_function = false
    subpage_layout_header.use_render_function_for_layout = false
    subpage_layout_header.allow_child_blocks = false
    subpage_layout_header.field_type = "block"
    subpage_layout_header.block_type_category_id = 2
    subpage_layout_header.save

    # Create subpage content block type
    old_subpage_layout_content = Caboose::BlockType.where(:parent_id => subpage_layout.id).where(:name => "content").last
    subpage_layout_content = old_subpage_layout_content ? old_subpage_layout_content : Caboose::BlockType.new
    subpage_layout_content.name = "content"
    subpage_layout_content.parent_id = subpage_layout.id
    subpage_layout_content.description = "Content"
    subpage_layout_content.use_render_function = false
    subpage_layout_content.use_render_function_for_layout = false
    subpage_layout_content.allow_child_blocks = true
    subpage_layout_content.field_type = "block"
    subpage_layout_content.block_type_category_id = 2
    subpage_layout_content.save

    # Create subpage footer block type
    old_subpage_layout_footer = Caboose::BlockType.where(:parent_id => subpage_layout.id).where(:name => "footer").last
    subpage_layout_footer = old_subpage_layout_footer ? old_subpage_layout_footer : Caboose::BlockType.new
    subpage_layout_footer.name = "footer"
    subpage_layout_footer.parent_id = subpage_layout.id
    subpage_layout_footer.description = "Footer"
    subpage_layout_footer.use_render_function = false
    subpage_layout_footer.use_render_function_for_layout = false
    subpage_layout_footer.allow_child_blocks = false
    subpage_layout_footer.field_type = "block"
    subpage_layout_footer.block_type_category_id = 2
    subpage_layout_footer.save

    # Create page custom fields
    old_pcf = Caboose::PageCustomField.where(:site_id => site.id, :key => "vertical_padding").first
    pcf = old_pcf ? old_pcf : Caboose::PageCustomField.new
    pcf.site_id = site.id
    pcf.key = "vertical_padding"
    pcf.name = "Vertical Padding"
    pcf.field_type = "text"
    pcf.default_value = "20px"
    pcf.sort_order = 0
    pcf.save

    if @store
        # Create products category
        old_product_category = Caboose::Category.where(:slug => "products").where(:site_id => site.id).last
        product_category = old_product_category ? old_product_category : Caboose::Category.new
        product_category.name = "All Products"
        product_category.parent_id = nil
        product_category.url = "/products"
        product_category.slug = "products"
        product_category.status = "Active"
        product_category.site_id = site.id
        product_category.save

        # Create vendor
        old_vendor = Caboose::Vendor.where(:name => site.description).where(:site_id => site.id).last
        vendor = old_vendor ? old_vendor : Caboose::Vendor.new
        vendor.name = site.description
        vendor.status = "Active"
        vendor.site_id = site.id
        vendor.save

        # Create products page
        old_product_page = Caboose::Page.where(:title => "Products", :site_id => site.id).last
        product_page = old_product_page ? old_product_page : Caboose::Page.new
        product_page.parent_id = home_page.id
        product_page.title = "Products"
        product_page.slug = "products"
        product_page.uri = "products"
        product_page.hide = false
        product_page.site_id = site.id
        product_page.save

        # Create layout block instance for products page
        old_block_3 = Caboose::Block.where(:page_id => product_page.id).where("parent_id IS NULL").last
        block_3 = old_block_3 ? old_block_3 : Caboose::Block.new
        block_3.page_id = product_page.id
        block_3.name = "layout_#{@site_name_slug}_subpage"
        block_3.parent_id = nil
        block_3.block_type_id = subpage_layout.id
        block_3.sort_order = 0
        block_3.save
        block_3.create_children
        block_3_content = block_3.child('content')
        block_3_content.constrain = true
        block_3_content.save

        # Create products block instance for products page
        old_block_4 = Caboose::Block.where(:page_id => product_page.id).where(:block_type_id => 657).last
        block_4 = old_block_4 ? old_block_4 : Caboose::Block.new
        block_4.page_id = product_page.id
        block_4.name = nil
        block_4.parent_id = block_3_content.id
        block_4.block_type_id = 657
        block_4.sort_order = 0
        block_4.save

        old_sc = Caboose::StoreConfig.where(:site_id => site.id).first
        sc = old_sc ? old_sc : Caboose::StoreConfig.new
        sc.site_id = site.id
        sc.pp_name = "stripe"
        sc.save
    end

    if @mls
        # Create residential page
        old_residential_page = Caboose::Page.where(:title => "Residential", :site_id => site.id).last
        residential_page = old_residential_page ? old_residential_page : Caboose::Page.new
        residential_page.parent_id = home_page.id
        residential_page.title = "Residential"
        residential_page.slug = "residential"
        residential_page.uri = "residential"
        residential_page.hide = false
        residential_page.site_id = site.id
        residential_page.save

        # Create RETS layout block instance for residential page
        old_block_5 = Caboose::Block.where(:page_id => residential_page.id).where("parent_id IS NULL").last
        block_5 = old_block_5 ? old_block_5 : Caboose::Block.new
        block_5.page_id = residential_page.id
        block_5.name = "layout_rets"
        block_5.parent_id = nil
        block_5.block_type_id = 1905
        block_5.sort_order = 0
        block_5.save
    end

    # Add basic block types to site's block type memberships
    default_block_types = [405,1,21,398,309,343,366,356,422,715,788,806,807,822,835,859,1049,1201,1306,815,1326,1368,1745,2045,2054,2164,2167,2342,1575,3159,3254,918]
    if @store
        default_block_types << 816
        default_block_types << 657
    end
    if @mls
        default_block_types << 1963
        default_block_types << 1905
        default_block_types << 2108
        default_block_types << 2124
        default_block_types << 2280
    end
    default_block_types.each do |bt|
      btsm = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => bt).last
      if !btsm
        btsm = Caboose::BlockTypeSiteMembership.new
        btsm.site_id = site.id
        btsm.block_type_id = bt
        btsm.save
      end
    end

    # Add home page layout to site's block type memberships
    btsm_1 = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => home_layout.id).last
    if !btsm_1
      btsm_1 = Caboose::BlockTypeSiteMembership.new
      btsm_1.site_id = site.id
      btsm_1.block_type_id = home_layout.id
      btsm_1.save
    end

    # Add subpage layout to site's block type memberships
    btsm_2 = Caboose::BlockTypeSiteMembership.where(:site_id => site.id, :block_type_id => subpage_layout.id).last
    if !btsm_2
      btsm_2 = Caboose::BlockTypeSiteMembership.new
      btsm_2.site_id = site.id
      btsm_2.block_type_id = subpage_layout.id
      btsm_2.save
    end

    # Make home page visible to everyone
    elo_role = Caboose::Role.where(:name => 'Everyone Logged Out', :site_id => site.id).first
    if elo_role
      r = elo_role.id
      per = Caboose::PagePermission.where(:role_id => r, :page_id => home_page.id, :action => 'view').last
      if !per
        per = Caboose::PagePermission.new
        per.role_id = r
        per.page_id = home_page.id
        per.action = 'view'
        per.save
      end
      per2 = Caboose::PagePermission.where(:role_id => r, :page_id => sub_page.id, :action => 'view').last
      if !per2
        per2 = Caboose::PagePermission.new
        per2.role_id = r
        per2.page_id = sub_page.id
        per2.action = 'view'
        per2.save
      end
    end

    # Create layout block instance for home page
    old_block_1 = Caboose::Block.where(:page_id => home_page.id).where("parent_id IS NULL").last
    block_1 = old_block_1 ? old_block_1 : Caboose::Block.new
    block_1.page_id = home_page.id
    block_1.name = "layout_#{@site_name_slug}_home"
    block_1.parent_id = nil
    block_1.block_type_id = home_layout.id
    block_1.sort_order = 0
    block_1.save

    # Create layout block instance for subpage
    old_block_2 = Caboose::Block.where(:page_id => sub_page.id).where("parent_id IS NULL").last
    block_2 = old_block_2 ? old_block_2 : Caboose::Block.new
    block_2.page_id = sub_page.id
    block_2.name = "layout_#{@site_name_slug}_subpage"
    block_2.parent_id = nil
    block_2.block_type_id = subpage_layout.id
    block_2.sort_order = 0
    block_2.save
    block_2.create_children
    block_2_content = block_2.child('content')
    block_2_content.constrain = true
    block_2_content.save
    
    # Create SMTP config variables for site
    old_smtp = Caboose::SmtpConfig.where(:site_id => site.id).last
    smtp = old_smtp ? old_smtp : Caboose::SmtpConfig.new
    smtp.site_id = site.id
    smtp.address = "email-smtp.us-east-1.amazonaws.com"
    smtp.port = "587"
    smtp.domain = "caboosecms.com"
    smtp.user_name = "AKIAILLCSBRZHLLN562Q"
    smtp.password = "Aro/z7tOf2atTa/Y4dhEjH1SQHWc7rF/ybzvEZ7wmXtl"
    smtp.authentication = "plain"
    smtp.enable_starttls_auto = true
    smtp.from_address = "noreply@caboosecms.com"
    smtp.save

    # Create default fonts for site
    Caboose::Font.where(:site_id => site.id, :name => 'body-font').exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font', :family => 'Lato', :variant => '300', :url => 'http://fonts.gstatic.com/s/lato/v11/Ja02qOppOVq9jeRjWekbHg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'button-font').exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'button-font', :family => 'Lato', :variant => '300', :url => 'http://fonts.gstatic.com/s/lato/v11/Ja02qOppOVq9jeRjWekbHg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'body-font-bold').exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font-bold', :family => 'Lato', :variant => '700', :url => 'http://fonts.gstatic.com/s/lato/v11/iX_QxBBZLhNj5JHlTzHQzg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'body-font-italic').exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font-italic', :family => 'Lato', :variant => '300italic', :url => 'http://fonts.gstatic.com/s/lato/v11/dVebFcn7EV7wAKwgYestUg.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'body-font-bold-italic').exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'body-font-bold-italic', :family => 'Lato', :variant => '700italic', :url => 'http://fonts.gstatic.com/s/lato/v11/WFcZakHrrCKeUJxHA4T_gw.ttf')
    Caboose::Font.where(:site_id => site.id, :name => 'heading-font').exists? ? false : Caboose::Font.create(:site_id => site.id, :name => 'heading-font', :family => 'Lato', :variant => 'regular', :url => 'http://fonts.gstatic.com/s/lato/v11/h7rISIcQapZBpei-sXwIwg.ttf')

    
    admin_password = password_generator(@site_name)
    puts "Admin password is: " + admin_password
    admin_user = Caboose::User.where(:username => 'admin', :site_id => site.id).first
    admin_user.password = Digest::SHA1.hexdigest(Caboose::salt + admin_password)
    admin_user.first_name = "Admin"
    admin_user.last_name = "User"
    admin_user.save

    admin_role = Caboose::Role.where(:name => 'Admin', :site_id => site.id).first
    admin_role ? Caboose::RoleMembership.create(:user_id => admin_user.id, :role_id => admin_role.id) : false

  end
  
  def create_site
    puts "Creating the site..."
    init_skeleton_files     
  end
  
  # Copies all the files in the sample directory to the host application
  def init_skeleton_files
    puts "Site name is #{@site_name}"
                         
    puts "Copying bootstrap files into site assets folder..."

    img_folder = "#{Caboose::site_assets_path}/#{@site_name_slug}/images"
    `mkdir -p #{img_folder}` if !File.exists?(img_folder)
    icons_folder = "#{Caboose::site_assets_path}/#{@site_name_slug}/images/icons"
    `mkdir -p #{icons_folder}` if !File.exists?(icons_folder)
    fonts_folder = "#{Caboose::site_assets_path}/#{@site_name_slug}/fonts"
    `mkdir -p #{fonts_folder}` if !File.exists?(fonts_folder)

    str = `find #{Rails.root}/bootstrap -type file`
    x = "#{Rails.root}/bootstrap".length + 1
    str.strip.split("\n").each do |file|
      next if file.ends_with?('.DS_Store')
      next if !@store && (file.include?('product') || file.include?('search_results')) 
      next if !@mls && file.include?('rets')

      file2 = "#{Caboose::site_assets_path}/#{@site_name_slug}/#{file[x..-1]}"
      file2 = file2.gsub('sitename',@site_name_slug)

      folder = File.dirname(file2)                
      `mkdir -p #{folder}` if !File.exists?(folder)
      `cp #{file} #{file2}` if !File.exists?(file2)
      
      next if !['.erb', '.css', '.js', '.scss'].include?(File.extname(file)) 
              
      f = File.open(file2, 'rb')
      str = f.read
      f.close
      if !@store
        str.gsub!('@import "|SITE_SLUG|/css/pages/products";','')
        str.gsub!('@import "|SITE_SLUG|/css/pages/product_details";','')
        str.gsub!('@import "|SITE_SLUG|/css/pages/product_index";','')
        str.gsub!('//= require |SITE_SLUG|/js/products','')
      end
      if !@mls
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
      str.gsub!("|SITE_SLUG|",@site_name_slug)
      str.gsub!("|SITE_NAME|",@site_name)    
      File.open(file2, 'w') { |f| f.write(str) }                
    end
      
    puts "Moving block files out of site assets folder..."    
    if !File.exists?("#{Rails.root}/app/views/caboose/blocks/#{@site_name_slug}")
      `mv #{Caboose::site_assets_path}/#{@site_name_slug}/blocks #{Rails.root}/app/views/caboose/blocks/#{@site_name_slug}`
    else
      `rm -rf #{Caboose::site_assets_path}/#{@site_name_slug}/blocks`        
    end
      
      #Find.find(skeleton_root).each do |file|    
      #  next if File.directory?(file)
      #  next if !@store && (file.include?('product') || file.include?('search_results'))
      #  next if !@mls && file.include?('rets')
      #  next if file.include?(".DS_Store")
      #  file2 = file.gsub(skeleton_root, '').gsub("sitename",@site_name_slug)
      #  file2 = "#{Caboose::site_assets_path}/#{@site_name_slug}/#{file2}"
      #
      #  FileUtils.cp(file, file2)
      #  
      #  #Replace any variables
      #  if File.extname(file2) == ".erb" || File.extname(file2) == ".css" || File.extname(file2) == ".js" || File.extname(file2) == ".scss"
      #    f = File.open(file2, 'rb')
      #    str = f.read
      #    f.close
      #    if !@store
      #      str.gsub!('@import "|SITE_SLUG|/css/pages/products";','')
      #      str.gsub!('@import "|SITE_SLUG|/css/pages/product_details";','')
      #      str.gsub!('@import "|SITE_SLUG|/css/pages/product_index";','')
      #      str.gsub!('//= require |SITE_SLUG|/js/products','')
      #    end
      #    if !@mls
      #      str.gsub!('@import "|SITE_SLUG|/css/pages/rets";','')
      #      str.gsub!('@import "|SITE_SLUG|/css/pages/rets_residential_details";','')
      #      str.gsub!('@import "|SITE_SLUG|/css/pages/rets_residential_index";','')
      #      str.gsub!("//= require |SITE_SLUG|/js/functions_rets","")
      #      str.gsub!("//= require photoswipe","")
      #      str.gsub!("//= require photoswipe_ui","")
      #      str.gsub!(" *= require photoswipe","")
      #      str.gsub!(" *= require photoswipe_skin","")
      #      str.gsub!("_skin","")
      #      str.gsub!("_ui","")
      #    end
      #    str.gsub!("|SITE_SLUG|",@site_name_slug)
      #    str.gsub!("|SITE_NAME|",@site_name)
      #    #str.gsub!("|HOME_PAGE_ID|",@home_page_id.to_s)
      #    File.open(file2, 'w') { |f| f.write(str) }
      #  end  
      #end
    
  end
  
end
