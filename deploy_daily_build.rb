# Deploys a daily UAR build
# The build number comes from either a CI tool or from the command line.

# TODO: pass in environment, daily or release, and application

require_relative './lib/daily_build_manager'

S3_BUCKET = "katt-packages"
#S3_BUCKET="kuali-coeus"
APPLICATION = "UAR"
BUILD_TYPE = "DAILY"


def get_build_number
  begin
    if ARGV.empty?
      raise "Build number is missing"
    else
      build_number = ARGV[0]
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
puts "Build to deploy: #{build_to_deploy}."
