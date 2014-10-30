# Deploys a daily UAR build

require_relative './lib/daily_build_manager'

S3_BUCKET="katt-packages"
#S3_BUCKET="kuali-coeus"

#if ARGV.empty?
#	build_number = "latest"
#else
#	build_number = ARGV[0]
#end

build_manager = DailyBuildManager.new(S3_BUCKET)

puts "available buckets are:"
build_manager.list_all_buckets

puts "contents of #{S3_BUCKET} bucket:"
build_manager.get_all_daily_packages