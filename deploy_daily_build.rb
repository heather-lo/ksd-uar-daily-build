# Deploys a daily UAR build
# The build number comes from either a CI tool or from the command line.

# TODO: pass in environment, daily or release, and application

require_relative './lib/daily_build_manager'

s3_bucket = "katt-packages"
s3_path = "kuali/kuali-coeus"
build_type = "daily"
application = "UAR"

def get_build_number
  begin
    if ARGV.empty?
      raise "Build number is missing"
    else
      build_number = ARGV[0]
    end
  end
end

build_manager = DailyBuildManager.new(s3_bucket)

# list available buckets are in S3
#build_manager.list_all_buckets

# list contents of #{s3_bucket}/#{s3_path}
#build_manager.list_bucket_objects(s3_bucket, s3_path)

# list desired type of packages
desired_packages = build_manager.get_desired_packages(s3_bucket, s3_path, build_type)

# get most recent package
package_path = desired_packages.last[:key]
puts "latest #{build_type} package path is: " + package_path

package_name = package_path.match(/kuali-coeus-5.2.1-(.*).tar.gz/)
puts "latest #{build_type} package name: " + package_name.to_s
puts "latest #{build_type} package for opsworks recipe: " + package_name[1]

#puts "getting specific build"
#build_to_deploy = get_build_number
#puts "Build to deploy: #{build_to_deploy}."
