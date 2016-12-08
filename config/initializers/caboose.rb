
# Salt to ensure passwords are encrypted securely
Caboose::salt = '42b2d7e5sdfsdf8cc730798f0a6a7395945afa6fa02b72'

# Where page asset files will be uploaded
Caboose::assets_path = Rails.root.join('app', 'assets', 'caboose')

# Register any caboose plugins
Caboose::plugins << 'CabooseCmsPlugin'

Caboose::use_url_params = false
Caboose::website_name = "Cabooseit"
Caboose::website_domain = "http://mywebsite.com"
Caboose::cdn_domain = Rails.env == 'development' ? 'd9hjv462jiw15.cloudfront.net' : 'd9hjv462jiw15.cloudfront.net'
Caboose::email_from = "contact@mywebsite.com"
#Caboose::authenticator_class = 'Authenticator'
Caboose::use_ab_testing = false
Caboose::session_length = 24 # hours
Caboose::schemas = [
  'Caboose::Schema',
  'Schema'  
]

# Absolute path or relative path from app directory
Caboose::site_assets_path = Rails.root.join('sites')

require 'paperclip/media_type_spoof_detector'
module Paperclip
  class MediaTypeSpoofDetector
    def spoofed?
      false
    end
  end
end
