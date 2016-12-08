Cabooseit::Application.configure do  
  # Paperclip config for S3 assets
  #config.paperclip_defaults = {
  #  :storage => :s3,
  #  :s3_credentials => {
  #    :bucket => 'cabooseit',
  #    :access_key_id => 'AKIAICC4PX3DLERBZURQ',
  #    :secret_access_key => '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'
  #  },
  #  :url => ':s3_alias_url',
  #  :s3_host_alias => 'd9hjv462jiw15.cloudfront.net'    
  #}
end

# Add it to initializer
Paperclip.options[:content_type_mappings] = {
  pdf: 'application/pdf'
}