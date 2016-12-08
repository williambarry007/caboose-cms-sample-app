module ApplicationHelper
  def self.nav_link(page, editing = false, down = false)
    link = ""
    if !page.nil? 
      link << '<a title="' + page.title + '" href="'
      if editing 
        link << '/admin/pages/#{page.id}/content">'
      else
        if !page.redirect_url.nil? && !page.redirect_url.blank?
          if page.redirect_url.start_with?('http')
            link << page.redirect_url + '" target="_blank" class="external">'
          else
            link << page.redirect_url + '" class="external">'
          end
        else
          if page.uri
            link << "/" + page.uri + '">'
          else
            link << '/">'
          end
        end
      end
      if !page.menu_title.blank? 
        if down
          link << page.menu_title.downcase
        else 
          link << page.menu_title
        end
      else
        if down && !page.title.blank?
          link << page.title.downcase
        else
          link << page.title
        end
      end
      link << "</a>"
    end
  end

  def self.active_nav_link(page, editing = false, down = false, current = nil)
    link = ""
    if !page.nil? 
      link << "<a title='#{page.title}' href='"
      if editing 
        link << "/admin/pages/#{page.id}/content'>"
      else
        same = false
        if current
          same = (current.id == page.id || current.parent_id == page.id) ? true : false
        end
      #  Caboose.log("page " + page.id.to_s + " same " + same.to_s)
        if !page.redirect_url.nil? && !page.redirect_url.blank?
          if page.redirect_url.start_with?('http:')
            link << page.redirect_url + "' target='_blank' class='external " + (same ? 'active' : '') + "'>"
          else
            link << page.redirect_url + "' class='external " + (same ? 'active' : '') + "'>"
          end
        else
          if page.uri
            link << "/" + page.uri + "'" + (same ? " class='active'" : '') + ">"
          else
            link << "/'" + (same ? " class='active'" : '') + ">"
          end
        end
      end
      if !page.menu_title.blank? 
        if down
          link << page.menu_title.downcase
        else 
          link << page.menu_title
        end
      else
        if down && !page.title.blank?
          link << page.title.downcase
        else
          link << page.title
        end
      end
      link << "</a>"
    end
  end

  def self.breadcrumbs(page)
    string = ""
    home_page = Caboose::Page.where(:site_id => page.site_id, :parent_id => -1).first
    level_1 = ''
    level_2 = ''
    level_3 = ''
    level_4 = ''
    level_5 = ''
    if home_page
      string << "<ul class='nav-breadcrumbs'>\n"
      if page && page.id != home_page.id 
        level_5 = "<li>" + self.nav_link(page, false) + "</li>\n"
        if page.parent && page.parent.id != home_page.id
          level_4 = "<li>" + self.nav_link(page.parent, false) + "</li>\n"
          if page.parent.parent && page.parent.parent.id != home_page.id
            level_3 = "<li>" + self.nav_link(page.parent.parent, false) + "</li>\n"
            if page.parent.parent.parent && page.parent.parent.parent.id != home_page.id
              level_2 = "<li>" + self.nav_link(page.parent.parent.parent, false) + "</li>\n"
              if page.parent.parent.parent.parent && page.parent.parent.parent.parent.id != home_page.id
                level_1 = "<li>" + self.nav_link(page.parent.parent.parent.parent, false) + "</li>\n"
              end
            end
          end
        end
      end
      string << "<li>" + self.nav_link(home_page, false) + "</li>\n"
      string << level_1 + level_2 + level_3 + level_4 + level_5 + "</ul>\n"
    end
    return string
  end

  def self.social_config(site_id, name)
    sc = Caboose::SocialConfig.where(:site_id => site_id).last
    result = ''
    if sc
      if name == "facebook_url"
        id = sc.facebook_page_id
        result = id.blank? ? "" : "https://www.facebook.com/#{id}"
      elsif name == "twitter_url"
        un = sc.twitter_username
        result = un.blank? ? "" : "https://www.twitter.com/#{un}"
      elsif name == "instagram_url"
        un = sc.instagram_username
        result = un.blank? ? "" : "https://www.instagram.com/#{un}"
      elsif name == "facebook_page_id"
        result = sc.facebook_page_id
      elsif name == "twitter_username"
        result = sc.twitter_username
      elsif name == "instagram_username"
        result = sc.instagram_username
      elsif name == "youtube_url"
        if sc.youtube_url && sc.youtube_url.include?('http')
          result = sc.youtube_url
        elsif sc.youtube_url && !sc.youtube_url.blank?
          result = "http://www.youtube.com/channel/" + sc.youtube_url
        end
      elsif name == "pinterest_url"
        result = sc.pinterest_url
      elsif name == "vimeo_url" && !sc.vimeo_url.blank?
        result = "http://www.vimeo.com/" + sc.vimeo_url
      elsif name == "rss_url"
        result = sc.rss_url
      elsif name == "google_plus_url"
        result = sc.google_plus_url
      elsif name == "linkedin_url"
        result = sc.linkedin_url
      elsif name == "google_analytics_id"
        result = sc.google_analytics_id
      end
    end
    if !result.blank?
      if result.start_with?("www.") && name && name.ends_with?("_url")
        return "http://" + result
      elsif !result.blank? && result.start_with?("http") && name && name.ends_with?("_url")
        return result
      elsif !result.blank? && name && name.ends_with?("_url")
        return "http://www." + result
      else
        return result
      end
    end
  end

  def self.social_links(site_id, shape = "", classes = "")
    site = Caboose::Site.where(:id => site_id).first
    html = '<span itemscope itemtype="http://schema.org/Organization">'
    html << "<meta itemprop='name' content='#{site.description}'>"
    html << "<link itemprop='url' href='http://#{site.primary_domain.domain}'>" if site && site.primary_domain && !site.primary_domain.domain.blank?
    html << "<ul class='social-links'>"
    options = ["facebook", "twitter", "instagram", "linkedin", "google_plus", "youtube", "vimeo", "pinterest", "rss"]
    classes = classes.gsub(","," ")
    options.each do |o|
      url = self.social_config(site_id, (o + "_url"))
      if !url.blank?
        name = o.gsub("_feed","").gsub("_","-")
        if shape == "outline" || shape == "circle"
          html << "<li><a href='#{url}' target='_blank' title='#{name.titleize}' class='icon-#{shape}-#{name} #{classes}'></a></li>"
        else
          html << "<li><a href='#{url}' target='_blank' title='#{name.titleize}' class='icon-#{name} #{classes}'></a></li>"
        end
      end
    end
    html << "</ul></span>"
    return html
  end

  def self.image_for_category(category_id)
    c = Caboose::Category.where(:id => category_id).first
    img = '//d9hjv462jiw15.cloudfront.net/assets/lockerroom/images/missing_image.jpg'
    if c
      if c.image && !c.image.url(:large).include?('placehold')
        img = c.image.url(:large)
      elsif c.active_products.first && c.active_products.first.featured_image && !c.active_products.first.featured_image.url(:large).include?('placehold')
        img = c.active_products.first.featured_image.url(:large)
      elsif c.children.count > 0 && c.children.first.image && !c.children.first.image.url(:large).include?('placehold')
        img = c.children.first.image.url(:large)
      elsif c.children.count > 0 && c.children.first.active_products.first && c.children.first.active_products.first.featured_image && !c.children.first.active_products.first.featured_image.url(:large).include?('placehold')
        img = c.children.first.active_products.first.featured_image.url(:large)
      elsif c.children.count > 0 && c.children.last.active_products.first && c.children.last.active_products.first.featured_image && !c.children.last.active_products.first.featured_image.url(:large).include?('placehold')
        img = c.children.last.active_products.first.featured_image.url(:large)
      end
    end
    return img
  end

  def self.pluralize_without_count(count, noun, text = nil)
    count == 1 ? "#{noun}#{text}" : "#{noun.pluralize}#{text}"
  end



end
