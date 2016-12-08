#require 'sprockets-derailleur'

Cabooseit::Application.configure do
  # Settings specified here will take precedence over those in config/application.rb  
  
  # In the development environment your application's code is reloaded on
  # every request. This slows down response time but is perfect for development
  # since you don't have to restart the web server when you make code changes.
  config.cache_classes = false

  # Log error messages when you accidentally call methods on nil.
  config.whiny_nils = true

  # Show full error reports and disable caching
  config.consider_all_requests_local       = true
  config.action_controller.perform_caching = false

  # Don't care if the mailer can't send
  config.action_mailer.raise_delivery_errors = false

  # Print deprecation notices to the Rails logger
  config.active_support.deprecation = :log

  # Only use best-standards-support built into browsers
  config.action_dispatch.best_standards_support = :builtin

  # Raise exception on mass assignment protection for Active Record models
  config.active_record.mass_assignment_sanitizer = :strict

  # Log the query plan for queries taking more than this (works
  # with SQLite, MySQL, and PostgreSQL)
  config.active_record.auto_explain_threshold_in_seconds = 0.5

  # Do not compress assets
  config.assets.compress = false
  #config.assets.compress = true

  # Expands the lines which load the assets
  config.assets.debug = true
  #config.assets.debug = false
  
  # Show action mailer errors for development
  ActionMailer::Base.raise_delivery_errors = true
  
  # Paperclip config - DEVELOPMENT BUCKET
  # config.paperclip_defaults = {
  #   :storage => :s3,
  #   :s3_credentials => {
  #     :bucket => 'cabooseit-dev',
  #     :access_key_id => 'AKIAJLF7Y6CJGSNHUJZA',
  #     :secret_access_key => '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'
  #   },
  #   :url => ':s3_alias_url',
  #   :s3_host_alias => 'd1bhcjivrdmfrh.cloudfront.net'    
  # }

  # Paperclip config - PRODUCTION BUCKET
  config.paperclip_defaults = {
    :storage => :s3,
    :s3_credentials => {
      :bucket => 'mybucket',
      :access_key_id => 'AKIAICCDLERBZURQDJFLKJ',
      :secret_access_key => 'wVtsdfsdffZYmFgOczcj2U0+4LFnXIABEOywB810Dsdf987jhb'
    },
    :url => ':s3_alias_url',
    :s3_host_alias => 'd9hjv462jiw15.cloudfront.net',
    :s3_protocol => '' # For protocol-relative URLs
  }
  
  # Use Cloudfront for asset hosting
  #config.action_controller.asset_host = "//d9hjv462jiw15.cloudfront.net"
  
  # Use the site assets for development
  config.assets.paths << "#{Rails.root}/../site_assets"  

end
