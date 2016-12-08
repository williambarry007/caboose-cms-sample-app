class CabooseCmsPlugin < Caboose::CaboosePlugin

  def self.admin_nav(nav, user = nil, page = nil, site)
    return nav if user.nil?

    if site.id == 124 # AAR
    
      item = {
        'id' => 'aar',
        'text' => 'AAR', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'events'     , 'href' => '/admin/aar-events'     , 'text' => 'Events'      , 'modal' => false }        
      item['children'] << { 'id' => 'reviews'     , 'href' => '/admin/aar-reviews'     , 'text' => 'Reviews'      , 'modal' => false }        
      item['children'] << { 'id' => 'associations'     , 'href' => '/admin/aar-associations'     , 'text' => 'Associations'      , 'modal' => false }        
      item['children'] << { 'id' => 'members'     , 'href' => '/admin/aar-members'     , 'text' => 'Association Employees'      , 'modal' => false }        
      nav << item

    end

    if site.id == 192 # E & A Team

      item = {
        'id' => 'eandateam',
        'text' => 'E & A Team', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'companies'     , 'href' => '/admin/companies'     , 'text' => 'Companies'      , 'modal' => false }       
      item['children'] << { 'id' => 'advertisements'     , 'href' => '/admin/advertisements'     , 'text' => 'Advertisements'      , 'modal' => false }             
      item['children'] << { 'id' => 'reports'     , 'href' => '/admin/reports'     , 'text' => 'Reports'      , 'modal' => false }       
      item['children'] << { 'id' => 'report-categories'     , 'href' => '/admin/report-categories'     , 'text' => 'Report Categories'      , 'modal' => false }       
      item['children'] << { 'id' => 'courses'     , 'href' => '/admin/courses'     , 'text' => 'Courses'      , 'modal' => false }       

      nav << item

    end

    if site.id == 131 # Soma

      item = {
        'id' => 'soma',
        'text' => 'Soma Church', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'prayers'     , 'href' => '/admin/prayers'     , 'text' => 'Prayers'      , 'modal' => false }     

      nav << item

    end

    if site.id == 178 # PreSchool Partners
      item = {
        'id' => 'psp',
        'text' => 'PreSchool Partners', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'product-sales'     , 'href' => '/admin/product-sales'     , 'text' => 'Product Sales'      , 'modal' => false }     
      nav << item
    end

    if site.id == 321 # Whitman
      item = {
        'id' => 'whitman',
        'text' => 'Walt Alabama Whitman', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'stories'     , 'href' => '/admin/stories'     , 'text' => 'Verses'      , 'modal' => false }     
      nav << item
    end

    if site.id == 191 && user.id != 26167 # Demopolis PD
      item = {
        'id' => 'dpd',
        'text' => 'Demopolis Police Department', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'offenders'     , 'href' => '/admin/offenders'     , 'text' => 'Sex Offenders & Most Wanted'      , 'modal' => false }     
      item['children'] << { 'id' => 'trainings'     , 'href' => '/admin/trainings'     , 'text' => 'Trainings'      , 'modal' => false }     
      nav << item
    end

    if site.id == 116 # Good Grit

      item = {
        'id' => 'goodgrit',
        'text' => 'Good Grit', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'adverts'     , 'href' => '/admin/adverts'     , 'text' => 'Advertisements'      , 'modal' => false }     

      nav << item

    end

    if site.id == 224 # Special Events
      item = {
        'id' => 'specialevents',
        'text' => 'Special Events', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'wishlists'     , 'href' => '/admin/wishlists'     , 'text' => 'Wish Lists'      , 'modal' => false }     
      item['children'] << { 'id' => 'contacts'     , 'href' => '/admin/contacts'     , 'text' => 'Contact Forms'      , 'modal' => false }    
      nav << item
    end

    if site.id == 316 # Morrow Companies

      item = {
        'id' => 'morrow',
        'text' => 'Morrow Companies', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'properties'     , 'href' => '/admin/properties'     , 'text' => 'Properties'      , 'modal' => false }     

      nav << item

    end

    if site.id == 278 # Aliceville

      item = {
        'id' => 'aliceville',
        'text' => 'Aliceville', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'businesses'     , 'href' => '/admin/businesses'     , 'text' => 'Businesses'      , 'modal' => false }     
      item['children'] << { 'id' => 'business-categories'     , 'href' => '/admin/business-categories'     , 'text' => 'Business Categories'      , 'modal' => false }     
      nav << item

    end

    if site.id == 328 # MSA Roof
      item = {
        'id' => 'msaroof',
        'text' => 'MSA Roof', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'rebates'     , 'href' => '/admin/rebates'     , 'text' => 'Rebates'      , 'modal' => false }     
      nav << item
    end

    if site.id == 317 # SEC Hospitality

      item = {
        'id' => 'sechosp',
        'text' => 'SEC Hospitality', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'events'     , 'href' => '/admin/events'     , 'text' => 'Events'      , 'modal' => false }     
      nav << item

    end

    if Colonnade::Campus.site_ids.include?(site.id) # The Colonnade Group
      campus = Colonnade::Campus.where(:site_id => site.id).first
      item = {
        'id' => 'colonnade',
        'text' => 'Hospitality', 
        'children' => [],
        'modal' => true
      }
      item['children'] << { 'id' => 'campuses'           , 'href' => '/admin/campuses/' + campus.id.to_s , 'text' => 'Campus Settings'    , 'modal' => false }     
      item['children'] << { 'id' => 'sports'             , 'href' => '/admin/sports'                     , 'text' => 'Sports'             , 'modal' => false }
      item['children'] << { 'id' => 'games'              , 'href' => '/admin/games'                      , 'text' => 'Games'              , 'modal' => false }
      item['children'] << { 'id' => 'venues'             , 'href' => '/admin/venues'                     , 'text' => 'Venues'             , 'modal' => false }
      item['children'] << { 'id' => 'suites'             , 'href' => '/admin/suites'                     , 'text' => 'Suites'             , 'modal' => false }
      item['children'] << { 'id' => 'menus'              , 'href' => '/admin/menus'                      , 'text' => 'Menus'              , 'modal' => false }
      item['children'] << { 'id' => 'suite-menus'        , 'href' => '/admin/suite-menus'                , 'text' => 'Suite Menus'        , 'modal' => false }
      item['children'] << { 'id' => 'suite-menu-reports' , 'href' => '/admin/suite-menu-reports'         , 'text' => 'Suite Menu Reports' , 'modal' => false }

      nav << item

    end

    return nav
      
  end
  
  def self.admin_user_tabs(tabs, user, site)
    if Colonnade::Campus.site_ids.include?(site.id) # The Colonnade Group      
      arr = tabs.to_a.insert(-2, ['Suiteholder Info', "/admin/users/#{user.id}/suiteholder-info"])
      tabs = Hash[arr]             
    end
    if site.id == 192 # E&A Team
      arr = tabs.to_a.insert(-2, ['Company Membership', "/admin/users/#{user.id}/company-info"])
      tabs = Hash[arr] 
    end
    # if site.id == 317 # SEC Hospitality
    #   arr = tabs.to_a.insert(-2, ['Renewal Options', "/admin/users/#{user.id}/renewal-options#user_id=#{user.id}"])
    #   tabs = Hash[arr] 
    # end
    if site.id == 182 # Fire Chief
      arr = tabs.to_a.insert(-2, ['Member Profile', "/admin/users/#{user.id}/membership"])
      tabs = Hash[arr] 
    end
    return tabs    
  end
  
end