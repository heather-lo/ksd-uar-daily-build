# Deploys a daily UAR build
# The build number comes from either a CI tool or from the command line.

require_relative './lib/daily_build_manager'

S3_BUCKET = "katt-packages"
#S3_BUCKET="kuali-coeus"


def get_build_number
	begin
		if ARGV.empty?
			raise "Build number is missing"
		else
			build_number = ARGV[0]
			puts "build_number is #{build_number}."
		end
	end
end

build_manager = DailyBuildManager.new(S3_BUCKET)

puts "available buckets are:"
build_manager.list_all_buckets

puts "contents of #{S3_BUCKET} bucket:"
build_manager.get_all_daily_packages

puts "getting specific build"
build_to_deploy = get_build_number
