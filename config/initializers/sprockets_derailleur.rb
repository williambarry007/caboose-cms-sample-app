#module Sprockets
#  class StaticCompiler
#
#    alias_method :compile_without_manifest, :compile
#    def compile
#      puts "Multithreading on " + SprocketsDerailleur.worker_count.to_s + " processors"
#      puts "Starting Asset Compile: " + Time.now.getutc.to_s
#
#      # Then initialize the manifest with the workers you just determined
#      manifest = Sprockets::Manifest.new(env, target)
#      manifest.compile paths
#
#      puts "Finished Asset Compile: " + Time.now.getutc.to_s
#
#    end
#  end
#
#  class Railtie < ::Rails::Railtie
#    config.after_initialize do |app|
#
#      config = app.config
#      next unless config.assets.enabled
#
#      #path = Rails.root.join('public', 'assets', 'manifest.yml')
#      if config.assets.manifest                
#        path = File.join(config.assets.manifest, "manifest.json")
#      else
#        path = File.join(Rails.public_path, config.assets.prefix, "manifest.json")
#      end
#
#      if File.exist?(path)
#        manifest = Sprockets::Manifest.new(app, path)
#        config.assets.digests = manifest.assets
#      end
#
#    end
#  end
#
#end