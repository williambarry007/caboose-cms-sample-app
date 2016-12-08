AssetSync.configure do |config| 
  config.fog_provider = 'AWS'
  config.fog_directory = 'cabooseit'
  config.aws_access_key_id = 'AKIAICC4PX3DLERBZURQ'
  config.aws_secret_access_key = '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'  
  config.run_on_precompile = true
end
