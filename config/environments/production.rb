Cabooseit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb

  # Code is not reloaded between requests
  config.cache_classes = true

  # Full error reports are disabled and caching is turned on
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = true

  # Disable Rails's static asset server (Apache or nginx will already do this)
  config.serve_static_assets = false

  # Compress JavaScripts and CSS
  config.assets.compress = true

  # Don't fallback to assets pipeline if a precompiled asset is missed
  config.assets.compile = true

  # Generate digests for assets URLs
  config.assets.digest = true

  # Defaults to nil and saved in location specified by config.assets.prefix
  # config.assets.manifest = YOUR_PATH

  # Specifies the header that your server uses for sending files
  # config.action_dispatch.x_sendfile_header = "X-Sendfile" # for apache
  # config.action_dispatch.x_sendfile_header = 'X-Accel-Redirect' # for nginx

  # Force all access to the app over SSL, use Strict-Transport-Security, and use secure cookies.
  # config.force_ssl = true

  # See everything in the log (default is :info)
  # config.log_level = :debug

  # Prepend all log lines with the following tags
  # config.log_tags = [ :subdomain, :uuid ]

  # Use a different logger for distributed setups
  # config.logger = ActiveSupport::TaggedLogging.new(SyslogLogger.new)
  config.logger = Logger.new(STDOUT) 
  config.log_level = :debug

  # Use a different cache store in production
  # config.cache_store = :mem_cache_store

  # Enable serving of images, stylesheets, and JavaScripts from an asset server
  # config.action_controller.asset_host = "http://assets.example.com"

  # Precompile additional assets (application.js, application.css, and all non-JS/CSS are already added)

  #config.assets.precompile += %w(projects.js, projects.css, jquery.floatThead.min.js)
  config.assets.precompile += [
    'projects.js', 'projects.css', 'jquery.floatThead.min.js', 'form_submit.js', 'maps.js', 'multiple_maps.js', 'youtube.js', 
    'jquery-ui/datepicker.css', 'jquery-ui/datepicker.js', 'fullCalendar.js', 'fullCalendar.css', 'moment.js', 'customSelect.js', 
    'rateit.css', 'rateit.js', 'residential_map_controller.js', 'cluster.js', 'photoswipe.js', 'photoswipe_ui.js', 'photoswipe.css', 'photoswipe_skin.css', 
    
    'newfield/js/newsletter_stocks_controller.js', 
    'col/*.js',
    'colonnade/js/*.js'
  ]

  # Disable delivery errors, bad email addresses will be ignored
  # config.action_mailer.raise_delivery_errors = false

  # Enable threaded mode
  # config.threadsafe!

  # Enable locale fallbacks for I18n (makes lookups for any locale fall back to
  # the I18n.default_locale when a translation can not be found)
  config.i18n.fallbacks = true

  # Send deprecation notices to registered listeners
  config.active_support.deprecation = :notify

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  # config.active_record.auto_explain_threshold_in_seconds = 0.5
  
  # Paperclip config for S3 assets
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => 'cabooseit',
      :access_key_id => 'AKIAICC4PX3DLERBZURQ',
      :secret_access_key => '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'
    },
    :url => ':s3_alias_url',
    :s3_host_alias => 'd9hjv462jiw15.cloudfront.net',
    :s3_protocol => '' # For protocol-relative URLs        
  }
  
  # Action mailer settings  
  config.action_mailer.delivery_method = :smtp
    
  # Use Cloudfront for asset hosting
  config.action_controller.asset_host = "d9hjv462jiw15.cloudfront.net"
end
