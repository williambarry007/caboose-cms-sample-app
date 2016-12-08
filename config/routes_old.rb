Cabooseit::Application.routes.draw do

  # Require for caboose routes to work
  if Caboose::use_comment_routes        
    eval(Caboose::CommentRoutes.controller_routes)      
  end
  
  get "/wbtest" => "forms#wbtest"
  get "/pingdom" => "pingdom#index"  
  get "dogs/test-email" => "dogs#test_email"
  get "dogs/test-host" => "dogs#test_host"
  
  # Newfield   
  #get    '/admin/newfield' => "newfield::index#admin_index"
                
  ## Dashboard
  #get    '/newfield/dashboard'                                             => "newfield::dashboard#index"
  #get    '/newfield/newsletters/:id/daily-reports/feed'                    => "newfield::daily_reports#calendar_feed"
  #get    '/newfield/newsletters/:newsletter_id/issues/:issue_id'           => "newfield::issues#show"
  #get    '/newfield/newsletters/:newsletter_id/daily-reports/:report_date' => "newfield::daily_reports#show"
  
  #get    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:report_id/stocks/options'          => 'newfield::daily_report_stocks#admin_options'
  #get    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:report_id/stocks/:field-options'   => 'newfield::daily_report_stocks#admin_options'
  #get    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:report_id/stocks/json'             => 'newfield::daily_report_stocks#admin_json'       
  #get    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:report_id/stocks/:id/json'         => 'newfield::daily_report_stocks#admin_json_single'
  #post   '/admin/newfield/newsletters/:newsletter_id/daily-reports/:report_id/stocks'                  => 'newfield::daily_report_stocks#admin_add'
  #put    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:report_id/stocks/:id'              => 'newfield::daily_report_stocks#admin_update'
  #delete '/admin/newfield/newsletters/:newsletter_id/daily-reports/:report_id/stocks/:id'              => 'newfield::daily_report_stocks#admin_delete'
    
  #post   '/newfield/newsletters/:newsletter_id/daily-reports'                       => "newfield::daily_reports#add_from_ken"  
  #get    '/admin/newfield/newsletters/:newsletter_id/daily-reports/json'            => "newfield::daily_reports#admin_json"
  #get    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:id/json'        => "newfield::daily_reports#admin_json_single"
  #get    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:id'             => "newfield::daily_reports#admin_edit"
  #post   '/admin/newfield/newsletters/:newsletter_id/daily-reports'                 => "newfield::daily_reports#admin_add"
  #put    '/admin/newfield/newsletters/:newsletter_id/daily-reports/:id'             => "newfield::daily_reports#admin_update"
  #delete '/admin/newfield/newsletters/:newsletter_id/daily-reports/:id'             => "newfield::daily_reports#admin_delete"
    
  #get    '/admin/newfield/newsletters/json'            => "newfield::newsletters#admin_json"
  #get    '/admin/newfield/newsletters/:id/json'        => "newfield::newsletters#admin_json_single"
  #get    '/admin/newfield/newsletters/new'             => "newfield::newsletters#admin_new"
  #get    '/admin/newfield/newsletters/options'         => "newfield::newsletters#admin_status_options"  
  #get    '/admin/newfield/newsletters/:field-options'  => "newfield::newsletters#admin_status_options"
  #get    '/admin/newfield/newsletters/:id'             => "newfield::newsletters#admin_edit"        
  #get    '/admin/newfield/newsletters'                 => "newfield::newsletters#admin_index"  
  #post   '/admin/newfield/newsletters'                 => "newfield::newsletters#admin_add"
  #put    '/admin/newfield/newsletters/:id'             => "newfield::newsletters#admin_update"  
  #delete '/admin/newfield/newsletters/:id'             => "newfield::newsletters#admin_delete"
    
  #get    '/admin/newfield/newsletters/:newsletter_id/issues/options'         => "newfield::issues#admin_options"
  #get    '/admin/newfield/newsletters/:newsletter_id/issues/:field-options'  => "newfield::issues#admin_options"
  #get    '/admin/newfield/newsletters/:newsletter_id/issues/json'            => "newfield::issues#admin_json" 
  #get    '/admin/newfield/newsletters/:newsletter_id/issues/:id/json'        => "newfield::issues#admin_json_single"
  #get    '/admin/newfield/newsletters/:newsletter_id/issues/:id'             => "newfield::issues#admin_edit"
  #post   '/admin/newfield/newsletters/:newsletter_id/issues'                 => "newfield::issues#admin_add"
  #put    '/admin/newfield/newsletters/:newsletter_id/issues/:id'             => "newfield::issues#admin_update"
  #delete '/admin/newfield/newsletters/:newsletter_id/issues/:id'             => "newfield::issues#admin_delete"

  #get    '/admin/newfield/newsletters/:newsletter_id/issues/:issue_id/stocks/json'     => "newfield::newsletter_stocks#admin_json" 
  #get    '/admin/newfield/newsletters/:newsletter_id/issues/:issue_id/stocks/:id/json' => "newfield::newsletter_stocks#admin_json_single"
  #post   '/admin/newfield/newsletters/:newsletter_id/issues/:issue_id/stocks'          => "newfield::newsletter_stocks#admin_add"
  #put    '/admin/newfield/newsletters/:newsletter_id/issues/:issue_id/stocks/:id'      => "newfield::newsletter_stocks#admin_update"
  #delete '/admin/newfield/newsletters/:newsletter_id/issues/:issue_id/stocks/:id'      => "newfield::newsletter_stocks#admin_delete"
  
  #get    '/admin/newfield/stocks/json'         => "newfield::stocks#admin_json"       
  #get    '/admin/newfield/stocks/:symbol/json' => "newfield::stocks#admin_json_single"
  #get    '/admin/newfield/stocks/:symbol'      => "newfield::stocks#admin_edit"
  #get    '/admin/newfield/stocks'              => "newfield::stocks#admin_index"
  #post   '/admin/newfield/stocks'              => "newfield::stocks#admin_add"
  #put    '/admin/newfield/stocks/:symbol'      => "newfield::stocks#admin_update"
  #delete '/admin/newfield/stocks/:symbol'      => "newfield::stocks#admin_delete"
        
  # Memorize Muscles
  #get   "/muscle-mailchimp-confirm" => "muscle#mailchimp_confirm"
  #post  "/muscle-mailchimp-confirm" => "muscle#mailchimp_confirm"
  #get   "/muscle-preview"           => "muscle#muscle_preview"
  
  # Newsletters
  #get   "/mailchimp/lists"             => "mailchimp#lists"
  #post  "/mailchimp/subscribe"         => "mailchimp#subscribe"
  #post  "/constantcontact/subscribe"   => "mailchimp#constantcontact"

  # EA Companies
  get     "/admin/companies"           => "ea::companies#admin_index"
  get     "/admin/companies/json"      => "ea::companies#admin_json"
  get     "/admin/companies/new"       => "ea::companies#admin_new"
  delete  "/admin/companies/bulk"      => "ea::companies#admin_bulk_delete"
  put     "/admin/companies/user/:id"  => "ea::companies#admin_edit_user"
  get     "/admin/companies/:id"       => "ea::companies#admin_edit"
  get     "/admin/companies/:id/json"  => "ea::companies#admin_json_single"
  post    "/admin/companies"           => "ea::companies#admin_add"
  put     "/admin/companies/:id"       => "ea::companies#admin_update"
  delete  "/admin/companies/:id"       => "ea::companies#admin_delete"

  # EA Report Categories
  get     "/admin/report-categories"           => "ea::report_categories#admin_index"
  get     "/admin/report-categories/json"      => "ea::report_categories#admin_json"
  get     "/admin/report-categories/new"       => "ea::report_categories#admin_new"
  delete  "/admin/report-categories/bulk"      => "ea::report_categories#admin_bulk_delete"
  get     "/admin/report-categories/:id"       => "ea::report_categories#admin_edit"
  get     "/admin/report-categories/:id/json"  => "ea::report_categories#admin_json_single"
  post    "/admin/report-categories"           => "ea::report_categories#admin_add"
  put     "/admin/report-categories/:id"       => "ea::report_categories#admin_update"
  delete  "/admin/report-categories/:id"       => "ea::report_categories#admin_delete"

  # EA Reports
  get     "/admin/reports"                                  => "ea::reports#admin_index"
  post    "/admin/reports/:id/increment-download"           => "ea::reports#increment_download"
  get     "/admin/reports/json"                             => "ea::reports#admin_json"
  get     "/admin/reports/new"                              => "ea::reports#admin_new"
  put     "/admin/reports/:id/companies/:company_id/toggle" => "ea::reports#admin_toggle_company"
  post    "/admin/reports/process"                          => "ea::reports#process_reports"
  get     "/admin/reports/status-options"                   => "ea::reports#admin_status_options"
  get     "/admin/reports/category-options"                 => "ea::reports#admin_category_options"
  get     "/admin/reports/company-options"                  => "ea::reports#admin_company_options"
  delete  "/admin/reports/bulk"                             => "ea::reports#admin_bulk_delete"
  get     "/admin/reports/:id"                              => "ea::reports#admin_edit"
  get     "/admin/reports/:id/json"                         => "ea::reports#admin_json_single"
  post    "/admin/reports"                                  => "ea::reports#admin_add"
  put     "/admin/reports/bulk"                             => "ea::reports#admin_bulk_update"
  put     "/admin/reports/:id"                              => "ea::reports#admin_update"
  delete  "/admin/reports/:id"                              => "ea::reports#admin_delete"

  # EA Advertisements
  get     "/admin/advertisements"                                  => "ea::advertisements#admin_index"
  get     "/admin/advertisements/json"                             => "ea::advertisements#admin_json"
  get     "/admin/advertisements/new"                              => "ea::advertisements#admin_new"
  put     "/admin/advertisements/:id/companies/:company_id/toggle" => "ea::advertisements#admin_toggle_company"
  post    "/admin/advertisements/:id/image"                        => "ea::advertisements#admin_update_image"
  get     "/admin/advertisements/status-options"                   => "ea::advertisements#admin_status_options"
  delete  "/admin/advertisements/bulk"                             => "ea::advertisements#admin_bulk_delete"
  get     "/admin/advertisements/:id"                              => "ea::advertisements#admin_edit"
  get     "/admin/advertisements/:id/json"                         => "ea::advertisements#admin_json_single"
  post    "/admin/advertisements"                                  => "ea::advertisements#admin_add"
  put     "/admin/advertisements/:id"                              => "ea::advertisements#admin_update"
  delete  "/admin/advertisements/:id"                              => "ea::advertisements#admin_delete"


  # EA Courses
  get     "/admin/courses"                => "ea::courses#admin_index"
  get     "/admin/courses/sort"           => "ea::courses#admin_sort"
  get     "/admin/courses/json"           => "ea::courses#admin_json"
  get     "/admin/courses/new"            => "ea::courses#admin_new"
  post    "/admin/courses/:id/image"      => "ea::courses#admin_update_image"
  get     "/admin/courses/status-options" => "ea::courses#admin_status_options"
  delete  "/admin/courses/bulk"           => "ea::courses#admin_bulk_delete"
  get     "/admin/courses/:id"            => "ea::courses#admin_edit"
  get     "/admin/courses/:id/json"       => "ea::courses#admin_json_single"
  post    "/admin/courses"                => "ea::courses#admin_add"
  put     "/admin/courses/:id"            => "ea::courses#admin_update"
  delete  "/admin/courses/:id"            => "ea::courses#admin_delete"

  # Demopolis Police - Sex Offenders & Most Wanted
  get     "/admin/offenders"                  => "demopolis::offenders#admin_index"
  get     "/admin/offenders/json"             => "demopolis::offenders#admin_json"
  get     "/admin/offenders/new"              => "demopolis::offenders#admin_new"
  post    "/admin/offenders/:id/image"        => "demopolis::offenders#admin_update_image"
  get     "/admin/offenders/status-options"   => "demopolis::offenders#admin_status_options"
  get     "/admin/offenders/sex-options"      => "demopolis::offenders#admin_sex_options"
  get     "/admin/offenders/category-options" => "demopolis::offenders#admin_category_options"
  delete  "/admin/offenders/bulk"             => "demopolis::offenders#admin_bulk_delete"
  get     "/admin/offenders/:id"              => "demopolis::offenders#admin_edit"
  get     "/admin/offenders/:id/json"         => "demopolis::offenders#admin_json_single"
  post    "/admin/offenders"                  => "demopolis::offenders#admin_add"
  put     "/admin/offenders/:id"              => "demopolis::offenders#admin_update"
  delete  "/admin/offenders/:id"              => "demopolis::offenders#admin_delete"

  # Good Grit Advertisements
  get     "/admin/adverts"           => "goodgrit::adverts#admin_index"
  get     "/admin/adverts/json"      => "goodgrit::adverts#admin_json"
  get     "/admin/adverts/new"       => "goodgrit::adverts#admin_new"
  put     "/admin/adverts/increment-clicks" => "goodgrit::adverts#increment_clicks"
  put     "/admin/adverts/:id/categories/:category_id/toggle" => "goodgrit::adverts#admin_toggle_category"
  post    "/admin/adverts/:id/image" => "goodgrit::adverts#admin_update_image"
  get     "/admin/adverts/status-options" => "goodgrit::adverts#admin_status_options"
  get     "/admin/adverts/kind-options" => "goodgrit::adverts#admin_kind_options"
  delete  "/admin/adverts/bulk"      => "goodgrit::adverts#admin_bulk_delete"
  get     "/admin/adverts/:id"       => "goodgrit::adverts#admin_edit"
  get     "/admin/adverts/:id/json"  => "goodgrit::adverts#admin_json_single"
  post    "/admin/adverts"           => "goodgrit::adverts#admin_add"
  put     "/admin/adverts/:id"       => "goodgrit::adverts#admin_update"
  delete  "/admin/adverts/:id"       => "goodgrit::adverts#admin_delete"


  # Soma Prayers
  post  "/utunum/prayer"            => "application#increase_prayer_count"
  post  "/soma/prayers/:id/increment" => "prayers#increase_prayer_count"
  post  "/soma/prayers/new"         => "prayers#new"
  get   "/soma/prayers/:id/delete"  => "prayers#delete"
  get   "/admin/prayers"            => "prayers#admin_index"
  get   "/admin/prayers/status-options" => "prayers#admin_status_options"
  get   "/admin/prayers/:id"        => "prayers#admin_edit"
  put   "/admin/prayers/:id"        => "prayers#admin_update"
  delete "/admin/prayers/:id"       => "prayers#admin_delete"

  # AAR Reviews
  get     "/admin/blocks/calendar-options" => "application#calendar_options"
  get     "/admin/aar-reviews"           => "aar_reviews#admin_index"
  get     "/admin/aar-reviews/json"      => "aar_reviews#admin_json"
  get     "/admin/aar-reviews/new"       => "aar_reviews#admin_new"
  delete  "/admin/aar-reviews/bulk"      => "aar_reviews#admin_bulk_delete"
  get     "/admin/aar-reviews/status-options" => "aar_reviews#admin_status_options"
  get     "/admin/aar-reviews/stars-options" => "aar_reviews#admin_stars_options"
  get     "/admin/aar-reviews/:id"       => "aar_reviews#admin_edit"
  get     "/admin/aar-reviews/:id/json"  => "aar_reviews#admin_json_single"
  post    "/admin/aar-reviews"           => "aar_reviews#admin_add"
  put     "/admin/aar-reviews/:id"       => "aar_reviews#admin_update"
  put     "/aar-reviews/user/new"       => "aar_reviews#user_new"
  delete  "/admin/aar-reviews/:id"       => "aar_reviews#admin_delete"

  # AAR Events
  get     "/admin/aar-events"           => "aar_events#admin_index"
  get     "/admin/aar-events/json"      => "aar_events#admin_json"
  get     "/admin/aar-events/new"       => "aar_events#admin_new"
  delete  "/admin/aar-events/bulk"      => "aar_events#admin_bulk_delete"
  get     "/admin/aar-events/calendar-options" => "aar_events#admin_calendar_options"
  get     "/admin/aar-events/status-options" => "aar_events#admin_status_options"
  get     "/admin/aar-events/:id"       => "aar_events#admin_edit"
  get     "/admin/aar-events/:id/json"  => "aar_events#admin_json_single"
  get     "/gri/courses/location/:location_name" => "aar_events#gri_location"
  post    "/admin/aar-events"           => "aar_events#admin_add"
  put     "/admin/aar-events/:id"       => "aar_events#admin_update"
  put     "/aar-events/user/new"       => "aar_events#user_new"
  delete  "/admin/aar-events/:id"       => "aar_events#admin_delete"

  # AAR Associations
  get     "/about/local-associations/:slug" => "aar_associations#show"
  get     "/admin/aar-associations"           => "aar_associations#admin_index"
  get     "/admin/aar-associations/json"      => "aar_associations#admin_json"
  get     "/admin/aar-associations/new"       => "aar_associations#admin_new"
  delete  "/admin/aar-associations/bulk"      => "aar_associations#admin_bulk_delete"
  get     "/admin/aar-associations/region-options" => "aar_associations#admin_region_options"
  get     "/admin/aar-associations/:id"       => "aar_associations#admin_edit"
  get     "/admin/aar-associations/:id/json"  => "aar_associations#admin_json_single"
  post    "/admin/aar-associations"           => "aar_associations#admin_add"
  put     "/admin/aar-associations/:id"       => "aar_associations#admin_update"
  delete  "/admin/aar-associations/:id"       => "aar_associations#admin_delete"

  # AAR Association Members
  get     "/admin/aar-members"           => "aar_association_members#admin_index"
  get     "/admin/aar-members/json"      => "aar_association_members#admin_json"
  get     "/admin/aar-members/new"       => "aar_association_members#admin_new"
  delete  "/admin/aar-members/bulk"      => "aar_association_members#admin_bulk_delete"
  get     "/admin/aar-members/association-options" => "aar_association_members#admin_association_options"
  get     "/admin/aar-members/:id"       => "aar_association_members#admin_edit"
  get     "/admin/aar-members/:id/json"  => "aar_association_members#admin_json_single"
  post    "/admin/aar-members"           => "aar_association_members#admin_add"
  put     "/admin/aar-members/:id"       => "aar_association_members#admin_update"
  delete  "/admin/aar-members/:id"       => "aar_association_members#admin_delete"
  post    "/admin/aar-members/:id/image" => "aar_association_members#admin_update_image"

  # TYATFP Fires
  get     "/admin/fires"           => "fires#admin_index"
  get     "/admin/fires/json"      => "fires#admin_json"
  get     "/admin/fires/new"       => "fires#admin_new"
  delete  "/admin/fires/bulk"      => "fires#admin_bulk_delete"
  get     "/admin/fires/:id"       => "fires#admin_edit"
  get     "/admin/fires/:id/json"  => "fires#admin_json_single"
  post    "/admin/fires"           => "fires#admin_add"
  put     "/admin/fires/:id"       => "fires#admin_update"
  put     "/fires/user/new"       => "fires#user_new"
  delete  "/admin/fires/:id"       => "fires#admin_delete"
  get     "fires/map-markers"      => "fires#map_markers"

  # Trello
  get  "trello/create-webhook"   => "trello#create_webhook"
  get  "trello/callback"         => "trello#thecallback"
  post "trello/callback"         => "trello#thecallback"
  get  "trello/test"             => "trello#test"

  # Sealy
  post   'sealy-lead/new'   => 'forms#sealy_lead'
  post   'sealy-referral/new'   => 'forms#sealy_referral'

  # Caboose API
  post   'form'             => 'forms#new'
  post   'search'         => 'search#results'
  get    'search'         => 'search#results'
  get   '/calendar/feed/:id'     => "calendars#feed"
  get   '/calendar/event/:id/json'     => "calendars#json"
  post  "/api/update-marker-coordinates" => "application#update_marker_coordinates"
  post  "/api/map-markers"         => "application#map_markers"
  post  "/api/custom-form"         => "application#custom_form"
  delete  "/api/custom-form"         => "application#delete_custom_form"
  post  "stripe/charge"            => "stripe#charge"
  post  "stripe/tickets"            => "stripe#tickets"
  post  "api/posts"                => "posts#api"
  post  "toji/patient"                => "forms#toji_patient"
  post  "api/polls/:id"            => "polls#new_response"
  get   "feed"                     => "posts#feed"

  # RETS
  get   "rets/residential"    => "rets#residential_json"
  get   "rets/residential/options/acreage"      => "rets#acreage_options"
  get   "rets/residential/options/price"        => "rets#price_options"
  get   "rets/residential/options/style"        => "rets#style_options"
  get   "rets/residential/options/elementary-school"      => "rets#elementary_options"
  get   "rets/residential/options/middle-school"      => "rets#middle_options"
  get   "rets/residential/options/high-school"      => "rets#high_options"
  get   "rets/residential/options/subdivision"        => "rets#subdivision_options"
  get   "rets/residential/options/property-type"        => "rets#property_type_options"
  get   "rets/residential/options/sqfeet"        => "rets#sqfeet_options"
  get   "rets/residential/options/waterfront"        => "rets#waterfront_options"
  
  # Gantt
  get  "admin/gantt"          => "gantt#admin_index"
  get  "admin/gantt/summary"  => "gantt#admin_summary"
  get  "admin/gantt/sync"     => "gantt#admin_sync"
  put  "admin/gantt/:card_id" => "gantt#admin_update"

  # Colonnade
  get    '/dashboard'       => "colonnade::dashboard#index"
  get    '/dashboard/order' => "colonnade::dashboard#order"
  get    '/dashboard/history' => "colonnade::dashboard#history"

  # Colonnade Campuses
  get     "/admin/campuses/timezone-options" => "colonnade::campuses#admin_timezone_options"
  get     "/admin/campuses/:id"       => "colonnade::campuses#admin_edit"
  put     "/admin/campuses/:id"       => "colonnade::campuses#admin_update"

  # Colonnade Sports
  get     "/admin/sports"           => "colonnade::sports#admin_index"
  get     "/admin/sports/kind-options" => "colonnade::sports#admin_kind_options"
  get     "/admin/sports/sport-options" => "colonnade::sports#admin_sport_options"
  get     "/admin/sports/json"      => "colonnade::sports#admin_json"
  get     "/admin/sports/new"       => "colonnade::sports#admin_new"
  put     "/admin/sports/user/:id"  => "colonnade::sports#admin_edit_user"
  get     "/admin/sports/:id"       => "colonnade::sports#admin_edit"
  get     "/admin/sports/:id/json"  => "colonnade::sports#admin_json_single"
  post    "/admin/sports"           => "colonnade::sports#admin_add"
  put     "/admin/sports/:id"       => "colonnade::sports#admin_update"
  delete  "/admin/sports/:id"       => "colonnade::sports#admin_delete"

  # Colonnade Games
  get     "/admin/games"           => "colonnade::games#admin_index"
  get     "/admin/games/json"      => "colonnade::games#admin_json"
  get     "/admin/games/new"       => "colonnade::games#admin_new"
  delete  "/admin/games/bulk"      => "colonnade::games#admin_bulk_delete"
  put     "/admin/games/user/:id"  => "colonnade::games#admin_edit_user"
  get     "/admin/games/:id"       => "colonnade::games#admin_edit"
  get     "/admin/games/:id/json"  => "colonnade::games#admin_json_single"
  post    "/admin/games"           => "colonnade::games#admin_add"
  put     "/admin/games/:id"       => "colonnade::games#admin_update"
  delete  "/admin/games/:id"       => "colonnade::games#admin_delete"

  # Colonnade Venues
  get     "/admin/venues"           => "colonnade::venues#admin_index"
  get     "/admin/venues/new"       => "colonnade::venues#admin_new"
  get     "/admin/venues/venue-options" => "colonnade::venues#admin_venue_options"
  get     "/admin/venues/:id/venue-options-all" => "colonnade::venues#admin_venue_options_all"
  put     "/admin/venues/user/:id"  => "colonnade::venues#admin_edit_user"
  get     "/admin/venues/:id"       => "colonnade::venues#admin_edit"
  post    "/admin/venues"           => "colonnade::venues#admin_add"
  put     "/admin/venues/:id"       => "colonnade::venues#admin_update"
  delete  "/admin/venues/:id"       => "colonnade::venues#admin_delete"

  
 # get   '/calendars/feed/:id'     => "calendars#feed"
  
  # Turn on caboose comment routes
  #routes = Caboose::CommentRoutes.parse_controllers
  #eval(routes)

 # Turn on caboose comment routes
  # eval(Caboose::CommentRoutes.controller_routes)
    
  # Catch everything with caboose
  mount CabooseRets::Engine => '/'
  mount Caboose::Engine => '/'
  match '*path' => 'caboose/pages#show'
  root :to      => 'caboose/pages#show'
end
