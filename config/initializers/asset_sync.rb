AssetSync.configure do |config| 
  config.fog_provider = 'AWS'
  config.fog_directory = 'mybucket'
  config.aws_access_key_id = 'AKIAIASLKDJLKCC4PX3DLERBZURQ'
  config.aws_secret_access_key = 'wVtZI+clxzcj2U0+4LFnXIABEOywB810D+LLKJLKJ'  
  config.run_on_precompile = true
end
