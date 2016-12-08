require 'caboose/site_helper'
require 'instagram'
require 'koala'
require 'open-uri'
require 'httparty'
require 'uri'

namespace :caboosecms do
  
  desc "Add devadmin domain to sites"
  task :add_devadmin_domain => :environment do
    Caboose::Site.reorder(:name).all.each do |site|
      d = Caboose::Domain.where(:site_id => site.id, :domain => "devadmin.#{site.name}.com:3000").first     
      Caboose::Domain.create(:site_id => site.id, :domain => "devadmin.#{site.name}.com:3000") if d.nil?      
    end    
  end

  desc "Send Aliceville business emails"
  task :aliceville_emails => :environment do
    count = 0
    Aliceville::Business.where('email IS NOT NULL').all.each do |b|
      puts "Sending email to " + b.name
      b.send_password_email
      count += 1
    end
    puts "sent " + count.to_s + " emails"
  end
  
  desc "Fix date authorized on orders"
  task :fix_date_authorized => :environment do
    Caboose::Invoice.where("(financial_status = ? or financial_status = ?) and date_authorized is null", 'authorized', 'captured').reorder(:id).all.each do |invoice|
      t = Caboose::InvoiceTransaction.where("invoice_id = ? and (transaction_type = ? or transaction_type = ?) and success = ?", invoice.id, Caboose::InvoiceTransaction::TYPE_AUTHORIZE, Caboose::InvoiceTransaction::TYPE_AUTHCAP, true).first
      next if t.nil?
      invoice.date_authorized = t.date_processed
      invoice.save
    end    
  end

  # desc "fire chief member role"
  # task :fc_roles => :environment do
  #   Caboose::User.where(:site_id => 182).all.each do |u|
  #     rm = Caboose::RoleMembership.where(:user_id => u.id, :role_id => 733).exists? ? Caboose::RoleMembership.where(:user_id => u.id, :role_id => 733).first : Caboose::RoleMembership.create(:user_id => u.id, :role_id => 733)
  #   end
  # end

  desc "fix ea reports"
  task :fix_reports => :environment do
    Ea::Report.all.each do |r|
      r.set_company_id
    end
  end

  desc "import map styles"
  task :import_map_styles => :environment do
    url = 'https://snazzymaps.com/favorites.json?key=71640512-9043-40ed-92d0-8e3d5d999ac3'
    response = HTTParty.get(url)
    response = JSON.parse(response.body)
    response['styles'].each do |style|
      puts 'Importing ' + style['name']
      ms = MapStyle.where(:alt_id => style['id'].to_i).first
      ms = MapStyle.create(:alt_id => style['id'].to_i) if ms.nil?
      ms.name = style['name']
      ms.description = style['description']
      ms.code = style['json']
      ms.save
    end
  end

  # desc "Fix company ids"
  # task :fix_company_ids => :environment do
  #   Ea::Report.all.each do |r|
  #     puts "processing report " + r.id.to_s
  #     rc = Ea::CompanyReport.where(:company_id => r.company_id, :report_id => r.id).exists?
  #     if !rc
  #       Ea::CompanyReport.create(:company_id => r.company_id, :report_id => r.id)
  #     end
  #   end
  # end

  desc "Fix product images order"
  task :fix_product_images_order => :environment do
    old_product_id = nil
    i = nil
    Caboose::ProductImage.where(:position => nil).reorder(:product_id, :id).all.each do |image|
      if image.product_id != old_product_id
        old_product_id = image.product_id
        i = 0
      end
      image.position = i
      image.save
      i = i + 1
    end              
  end
  
  desc "Fix product options sort order"
  task :fix_product_options_sort_order => :environment do
    old_product_id = nil
    i = nil    
    Caboose::Variant.where("option1 is not null and option1_sort_order is null").reorder(:product_id, :id).all.each do |v|
      if v.product_id != old_product_id
        old_product_id = v.product_id
        i = 0
      end
      v.option1_sort_order = i
      v.save
      i = i + 1
    end
    old_product_id = nil
    i = nil
    Caboose::Variant.where("option2 is not null and option2_sort_order is null").reorder(:product_id, :id).all.each do |v|
      if v.product_id != old_product_id
        old_product_id = v.product_id
        i = 0
      end
      v.option2_sort_order = i
      v.save
      i = i + 1
    end
    old_product_id = nil
    i = nil
    Caboose::Variant.where("option3 is not null and option3_sort_order is null").reorder(:product_id, :id).all.each do |v|
      if v.product_id != old_product_id
        old_product_id = v.product_id
        i = 0
      end
      v.option3_sort_order = i
      v.save
      i = i + 1
    end
  end    
  
  desc "Initialize block type site memberships"
  task :init_site_memberships => :environment do
    
    query = ["select id from block_types where parent_id is null order by id"]        
    rows = ActiveRecord::Base.connection.select_rows(ActiveRecord::Base.send(:sanitize_sql_array, query))
    block_type_ids = rows.collect { |row| row[0] }
    
    query = ["select id from sites order by id"]        
    rows = ActiveRecord::Base.connection.select_rows(ActiveRecord::Base.send(:sanitize_sql_array, query))
    site_ids = rows.collect { |row| row[0] }
    
    site_ids.each do |site_id|
      block_type_ids.each do |block_type_id|
        if !Caboose::BlockTypeSiteMembership.where(:block_type_id => block_type_id, :site_id => site_id).exists?
          Caboose::BlockTypeSiteMembership.create(:block_type_id => block_type_id, :site_id => site_id)
        end
      end
    end

  end

  desc "Update social media caches"
  task :refresh_social_cache => :environment do
    Rake::Task["caboosecms:refresh_instagram_cache"].invoke
    Rake::Task["caboosecms:refresh_facebook_cache"].invoke
    Rake::Task["caboosecms:refresh_twitter_cache"].invoke
    Rake::Task["caboosecms:refresh_youtube_cache"].invoke
    Rake::Task["caboosecms:refresh_vimeo_cache"].invoke
  end

  desc "Refresh Instagram Cache"
  task :refresh_instagram_cache => :environment do
    puts "Connecting to Instagram API..."
    usernames_seen = []
    Instagram.configure do |config|
      config.client_id = "bac12987b6cb4262a004f3ffc388accc"
      config.client_secret = "ede277a5b2df47fe8efcb69a9fac8e07"
    end
    usernames2 = Caboose::SocialConfig.where("instagram_access_token IS NOT NULL").all
    usernames2.each do |u|
      client = Instagram.client(:access_token => u.instagram_access_token)
      user = client ? client.user : nil
      usernames_seen << user.username if user
      puts "Refreshing Instagram cache for #{user.username}..." if user
      if client && user
        images =  client.user_recent_media({:count => 25})
        if images && images.count > 0
          images.each do |i|
            old = InstagramCache.where(:instagram_id => i.id).exists?
            next if i.images.blank?
            if !old
              puts "Importing image #{i.id}..."
              ig = InstagramCache.new
              ig.site_id = u.site_id
              ig.image_url = i.images.standard_resolution.url
              ig.link_url = i.link
              ig.instagram_id = i.id
              if i.user
                ig.username = i.user.username
              end
              if i.caption
                ig.caption = i.caption.text
              end
              if i.location
                ig.location = i.location.name
              end
              ig.date_created = i.created_time
              ig.save
            else
              puts "Found duplicate image, skipping..."
            end
          end
        end
      end
      # Only keep the latest 25 images for this user, delete older ones
      puts "Deleting old images for #{user.username}..."
      image_limit = 25
      all_images = InstagramCache.where(:username => user.username).order("date_created DESC").all
      if all_images.count > image_limit
        (image_limit..(all_images.count - 1)).each do |i|
          puts "Deleting image #{all_images[i].id}"
          all_images[i].destroy
        end
      end
    end
    # Delete images from users that are no longer referenced from the site
    # users = usernames_seen.count > 0 ? usernames_seen.to_s.downcase.gsub("[","(").gsub("]",")").gsub('"',"'") : ''
    # old_images = InstagramCache.where("lower(username) NOT IN #{users}").all
    # old_images.each do |o|
    #   puts "Deleting image #{o.id} with username #{o.username}..."
    #   o.destroy
    # end
    puts "Done!"
  end

  desc "Refresh Facebook Cache"
  task :refresh_facebook_cache => :environment do
    puts "Connecting to Facebook API..."
    begin
      graph = Koala::Facebook::API.new("310334165828072|ZJy128CdqWaH4FRsQH4IX4XKj5M")
      pages_seen = []
      page_ids2 = Caboose::SocialConfig.all
      page_ids2.each do |p|
        next if pages_seen.include?(p.facebook_page_id) || p.facebook_page_id.blank? || p.facebook_page_id == "#"
        puts "Refreshing Facebook cache for #{p.facebook_page_id}..."
        pages_seen << p.facebook_page_id
        profile = graph.get_picture(p.facebook_page_id)
        fb_page_name = graph.get_object(p.facebook_page_id)['name']
        feed = graph.get_connections(p.facebook_page_id,"posts", { :limit => 20, :type => "large" })
        feed.each do |f|
          old = FacebookCache.where(:post_id => f['id'].to_s).exists?
          if !old
            puts "Importing post #{f['id']}..."
            fb = FacebookCache.new
            fb.page_name = fb_page_name
            fb.site_id = p.site_id
            fb.page_id = p.facebook_page_id
            fb.page_url = "http://www.facebook.com/#{p.facebook_page_id}"
            fb.profile_img = profile
            fb.post_id = f['id'].to_s
            fb.description = f['description']
            fb.name = f['name']
            fb.post_type = f['type']
            fb.status_type = f['status_type']
            fb.post_url = ("http://www.facebook.com/#{p.facebook_page_id}/posts/" + f['id']).gsub("#{p.facebook_page_id}_","")
            fb.link = f['link']
            fb.story = f['story']
            fb.message = f['message']
            fb.picture = f['picture']
            fb.date_created = f['created_time']
            fb.save
          else 
            puts "Found duplicate post, skipping..."
          end
        end
        # Only keep the latest 20 posts for this page, delete older ones
        puts "Deleting old posts for #{p.facebook_page_id}..."
        post_limit = 20
        all_posts = FacebookCache.where(:page_id => p.facebook_page_id).order("date_created DESC").all
        if all_posts.count > post_limit
          (post_limit..(all_posts.count - 1)).each do |i|
            puts "Deleting post #{all_posts[i].id}"
            all_posts[i].destroy
          end
        end
      end
      # Delete posts from pages that are no longer referenced from the site
      pages = pages_seen.to_s.gsub("[","(").gsub("]",")").gsub('"',"'")
      old_posts = FacebookCache.where("page_id NOT IN #{pages}").all
      old_posts.each do |o|
        puts "Deleting post #{o.id} with page_id #{o.page_id}..."
        o.destroy
      end
    rescue => error
      puts "Error connecting to Facebook API."
      puts $!, $@
    end
    puts "Done!"
  end

  desc "Refresh Twitter Cache"
  task :refresh_twitter_cache => :environment do
    puts "Connecting to Twitter API..."
    usernames_seen2 = []
    usernames3 = Caboose::SocialConfig.all
    usernames3.each do |u|
      next if u.twitter_username.blank? || usernames_seen2.include?(u.twitter_username.downcase)
      puts "Refreshing Twitter cache for #{u.twitter_username.downcase}..."
      usernames_seen2 << u.twitter_username.downcase
      tweets = Twittery.latest_tweets(u.twitter_username, 20)
      if tweets && tweets.count > 0
        tweets.each do |t|
          old = TwitterCache.where(:tweet_id => t.id.to_s).exists?
          if !old
            puts "Importing tweet #{t.id}"
            tw = TwitterCache.new
            tw.site_id = u.site_id
            tw.body = Twittery.auto_link(t.text)
            tw.tweet_id = t.id
            tw.username = u.twitter_username.downcase
            tw.created_at = t.created_at
            tw.tweet_url = "http://www.twitter.com/#{u.twitter_username}/status/" + t.id.to_s
            tw.save
          else
            puts "Found duplicate tweet, skipping..."
          end
        end
      end
      # Only keep the latest 20 tweets for this user, delete older ones
      puts "Deleting old tweets for #{u.twitter_username.downcase}..."
      tweet_limit = 20
      all_tweets = TwitterCache.where(:username => u.twitter_username.downcase).order("created_at DESC").all
      if all_tweets.count > tweet_limit
        (tweet_limit..(all_tweets.count - 1)).each do |i|
          puts "Deleting tweet #{all_tweets[i].id}"
          all_tweets[i].destroy
        end
      end
    end
    # Delete tweets from users that are no longer referenced from the site
    users2 = usernames_seen2.to_s.downcase.gsub("[","(").gsub("]",")").gsub('"',"'")
    old_tweets = TwitterCache.where("username NOT IN #{users2}").all
    old_tweets.each do |o|
      puts "Deleting tweet #{o.id} with username #{o.username}..."
      o.destroy
    end
  end

  desc "Refresh YouTube Cache"
  task :refresh_youtube_cache => :environment do
    puts "Connecting to YouTube API..."
    begin 
      Yt.configure do |config|
        config.api_key = 'AIzaSyAjSs-Jq6hpuT35RG9wD6LuqaDFzYDCOPk'
      end
      usernames_seen3 = []
      usernames4 = Caboose::SocialConfig.all
      usernames4.each do |u|
     #   puts "Refreshing YouTube cache for #{u.youtube_url}..."
        next if u.youtube_url.blank? || !u.youtube_url.include?('http')
        channel = Yt::Channel.new url: u.youtube_url
        next if usernames_seen3.include?(channel.title)
        puts "Refreshing YouTube cache for #{channel.title}..."
        usernames_seen3 << channel.title
        if channel && channel.videos && channel.videos.count > 0
          channel.videos.first(20).each do |v|
            old = YoutubeCache.where(:video_id => v.id).exists?
            next if v.title == "https://youtube.com/devicesupport"
            if !old
              puts "Importing video #{v.id}"
              yt = YoutubeCache.new
              yt.site_id = u.site_id
              yt.title = v.title
              yt.description = v.description
              yt.video_id = v.id
              yt.view_count = v.view_count
              yt.username = channel.title
              tb_url = v.thumbnail_url
              yt.thumbnail_url = v.thumbnail_url(:high)
              yt.uploaded_at = v.published_at
              yt.video_url = "http://www.youtube.com/watch?v=" + v.id
              yt.save
            else
              puts "Found duplicate video, skipping..."
            end
          end
        end
        # Only keep the latest 20 videos for this user, delete older ones
        puts "Deleting old videos for #{u.youtube_url}..."
        video_limit = 20
        all_videos = YoutubeCache.where(:username => channel.title).order("uploaded_at DESC").all
        if all_videos.count > video_limit
          (video_limit..(all_videos.count - 1)).each do |i|
            puts "Deleting video #{all_videos[i].id}"
            all_videos[i].destroy
          end
        end
      end
      # Delete videos from users that are no longer referenced from the site
      users3 = usernames_seen3.to_s.downcase.gsub("[","(").gsub("]",")").gsub('"',"'")
      old_videos = YoutubeCache.where("lower(username) NOT IN #{users3}").all
      old_videos.each do |o|
        puts "Deleting video #{o.video_id} with username #{o.username}..."
        o.destroy
      end
    rescue => error
      puts "Error connecting to YouTube API."
      puts $!, $@ 
    end
    puts "Done!"
  end

  desc "Refresh Vimeo Cache"
  task :refresh_vimeo_cache => :environment do
    puts "Connecting to Vimeo API..."
    begin 
      usernames_seen4 = []
      usernames5 = Caboose::SocialConfig.all
      usernames5.each do |u|
        next if u.vimeo_url.blank? || u.vimeo_url.include?('http') || usernames_seen4.include?(u.vimeo_url)
        videos = Vimeo::Simple::User.videos(u.vimeo_url)
        puts "Refreshing Vimeo cache for #{u.vimeo_url}..."
        if videos && videos[0]
          usernames_seen4 << videos[0]['user_name']
          videos.each do |v|
            vim = VimeoCache.where(:video_id => v['id'].to_s).exists? ? VimeoCache.where(:video_id => v['id'].to_s).first : VimeoCache.new
            puts "Importing video #{v['title']}"
            vim.site_id = u.site_id
            vim.title = v['title']
            vim.description = v['description']
            vim.video_id = v['id'].to_s
            vim.username = v['user_name']
            vim.thumbnail_url = v['thumbnail_large']
            vim.uploaded_at = v['upload_date']
            vim.video_url = v['url']
            vim.tags = v['tags']
            vim.view_count = v['stats_number_of_plays']
            vim.like_count = v['stats_number_of_likes']
            vim.save
          end
        end
        # Only keep the latest 20 videos for this user, delete older ones
        puts "Deleting old videos for #{u.vimeo_url}..."
        video_limit = 20
        all_videos = VimeoCache.where(:site_id => u.site_id).order("uploaded_at DESC").all
        if all_videos.count > video_limit
          (video_limit..(all_videos.count - 1)).each do |i|
            puts "Deleting video #{all_videos[i].id}"
            all_videos[i].destroy
          end
        end
      end
      # Delete videos from users that are no longer referenced from the site
      users4 = usernames_seen4.to_s.downcase.gsub("[","(").gsub("]",")").gsub('"',"'")
      if users4 != "()"
        old_videos = VimeoCache.where("lower(username) NOT IN #{users4}").all
        old_videos.each do |o|
          puts "Deleting video #{o.video_id} with username #{o.username}..."
          o.destroy
        end
      end
    rescue => error
      puts "Error connecting to Vimeo API."
      puts $!, $@ 
    end
    puts "Done!"
  end

  desc "Create a new lite site"
  task :create_site_skeleton => :environment do
    
    if Rails.env != 'development'
      puts "This task should be run on development, then the resulting files should pushed up to production."
      exit
    end
        
    puts "\n"
    puts "--------------------------------------------------------------------------------\n"
    puts "Create a new Nine Lite site\n"
    puts "--------------------------------------------------------------------------------\n"

    input = ''
    STDOUT.puts "What is the name of the site?"
    input = STDIN.gets.chomp
    puts "\n"

    input3 = ''
    STDOUT.puts "Store? (y/n)"
    input3 = STDIN.gets.chomp
    puts "\n"

    input4 = ''
    STDOUT.puts "MLS? (y/n)"
    input4 = STDIN.gets.chomp
    puts "\n"

    if !input.blank? && !input3.blank? && !input4.blank?
      helper = SiteHelper.new(input,input3,input4)
      helper.create_site

      puts "\n"
      puts "--------------------------------------------------------------------------------\n"
      puts "Choo! Choo! Your site is set up!\n"
      puts "--------------------------------------------------------------------------------\n"
    else
      puts "Invalid site name or home page ID"
    end
  end

  desc "Create blocks for new site"
  task :create_site_blocks => :environment do
        
    puts "Note: This task creates block types in the database. It needs to be run on the production environment.\n\n"
        
    puts "\n"
    puts "--------------------------------------------------------------------------------\n"
    puts "Create blocks for new site\n"
    puts "--------------------------------------------------------------------------------\n"

    input = ''
    STDOUT.puts "What is the name of the site?"
    input = STDIN.gets.chomp
    puts "\n"

    input2 = ''
    STDOUT.puts "Store? (y/n)"
    input2 = STDIN.gets.chomp
    puts "\n"

    input3 = ''
    STDOUT.puts "MLS? (y/n)"
    input3 = STDIN.gets.chomp
    puts "\n"

    if !input.blank? && !input2.blank? && !input3.blank?
      helper = SiteHelper.new(input,input2,input3)
      helper.create_site_blocks

      puts "\n"
      puts "--------------------------------------------------------------------------------\n"
      puts "Choo! Choo! Your blocks have been created!\n"
      puts "--------------------------------------------------------------------------------\n"
    else
      puts "Invalid site name."
    end
  end

  desc "Add bulk map markers to a Multiple Locations Map block"
  task :add_map_markers => :environment do
    map_id = 43679
    map = Caboose::Block.where(:id => map_id).last
    if map
      data = [
        # ["Loosa Brews","412 20th Ave","Tuscaloosa, AL", 33.2118227,-87.5632931, 43],
        # ["Mellow Mushroom","230 University Blvd","Tuscaloosa, AL", 33.210627,-87.566831, 44],
        # ["Moe's Original BBQ","101 University Blvd","Tuscaloosa, AL", 33.21068,-87.564362, 45],
        # ["Rounders","215 University Blvd","Tuscaloosa, AL", 33.21076,-87.553951, 46]
      ]

 #     delete from blocks where parent_id in (select id from blocks where parent_id = 28122 and block_type_id = 1373) OR (parent_id = 28122 and block_type_id = 1373)

      data.each_with_index do |row,i|
        puts "Importing marker " +  (i + 1).to_s + " of " + data.count.to_s + ": " + row[0]
        marker = Caboose::Block.create(
          :block_type_id => 1373,
          :page_id => map.page_id, 
          :parent_id => map.id
        )
        marker.create_children
        address = marker.child('address')
        address.value = row[1] + ", " + row[2]
        address.save
        title = marker.child('title')
        title.value = row[0]
        title.save
        text = marker.child("info_box_text")
       # website = row[3]
      #  if !website.blank?
      #    text.value = "<p>" + row[1] + ", " + row[2] + "<br />" + row[2] + "<br /><a href='http://" + website + "' target='_blank'>Website</a></p>" 
      #  else
          text.value = "<p>" + row[1] + ", " + row[2] + "</p>" 
      #  end
        text.save
        # response = HTTParty.get("http://maps.googleapis.com/maps/api/geocode/json?address=" + URI.encode(row[1] + ", " + row[2]) + "&sensor=false")
        # response = JSON.parse(response.body)
        # if response['status'] != "ZERO_RESULTS"
           lat = marker.child('latitude')
           lat.value = row[3]
          # lat.value = response['results'][0]['geometry']['location']['lat']
          lat.save
          lng = marker.child('longitude')
          lng.value = row[4]
          # lng.value = response['results'][0]['geometry']['location']['lng']
          lng.save
        # end
      end
    end
  end

  desc "Make sure all active subscriptions have an invoice"
  task :create_subscription_invoices => :environment do
    Subscription.create_invoices
  end

  # desc "Add Good Grit users"
  # task :add_gg_users => :environment do
  #   data = [
  #     ["adrian.zebot@gmail.com","Debbie","Zebot","535 Gardenia Drive","Vero Beach","32963","FL","7727666003","GoodGritSubscriber"],
  #   ]
  #   data.each_with_index do |row,i|
  #     puts "Importing user " +  (i + 1).to_s + " of " + data.count.to_s + ": " + row[1] + " " + row[2]
  #     u = Caboose::User.where(:email => row[0], :zip => row[5]).exists? ? Caboose::User.where(:email => row[0], :zip => row[5]).first : Caboose::User.new
  #     u.first_name = row[1]
  #     u.last_name = row[2]
  #     u.email = row[0]
  #     u.address = row[3]
  #     u.city = row[4]
  #     u.state = row[6]
  #     u.zip = row[5]
  #     u.phone = row[7]
  #     u.password = Digest::SHA1.hexdigest(Caboose::salt + 'GGMexclusive2015')
  #     u.date_created = DateTime.now
  #     u.utc_offset = -5
  #     u.site_id = 116
  #     u.timezone = 'Central Time (US & Canada)'
  #     u.save
  #     rm = Caboose::RoleMembership.where(:user_id => u.id, :role_id => 116).exists? ? Caboose::RoleMembership.where(:user_id => u.id, :role_id => 116).first : Caboose::RoleMembership.new
  #     rm.user_id = u.id
  #     rm.role_id = 116
  #     rm.save
  #   end
  # end



end
