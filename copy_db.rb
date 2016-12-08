require 'date'

dump_file = "~/Desktop/db/caboosecms_production_#{DateTime.now.strftime('%Y%m%d%H%M')}.dump"

puts "Capturing production database..."
`heroku pg:backups capture --app caboose`

puts "Downloading captured database..."
`curl -o #{dump_file} \`heroku pg:backups public-url --app caboose\``

puts "Restoring to local database..."
`pg_restore --verbose --clean --no-acl --no-owner -h localhost -U root -d caboosecms_development #{dump_file}`

puts "Finished.\n"

